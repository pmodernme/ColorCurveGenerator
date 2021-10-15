//
//  ColorCurveViewModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation
import Shared
import SwiftUI

final class ColorCurveViewModel: ObservableObject {
    
    struct State {
        let hue: Double
        let saturation: Double
        let brightness: Double
        let alpha: Double
        let previousEnabled: Bool
        let nextEnabled: Bool
        let deleteEnabled: Bool
        let color: Color
        
        let possibleHueColors: [Color]
        let possibleSatColors: [Color]
        let possibleBriColors: [Color]
        let possibleAlphaColors: [Color]
    }
    
    @Published var state: State
    
    private var curve: ColorCurve
    
    init() {
        curve = BasicColorCurve(nodes: [])
        state = stateFrom(hue: 0.0, curve: curve)
    }
    
    func onHueChange(_ hue: Double) {
        state = stateFrom(hue: hue, curve: curve)
    }
    
    func onSaturationChange(_ saturation: Double) {
        onChange(s: saturation, b: state.brightness, a: state.alpha)
    }
    
    func onBrightnessChange(_ brightness: Double) {
        onChange(s: state.saturation, b: brightness, a: state.alpha)
    }
    
    func onAlphaChange(_ alpha: Double) {
        onChange(s: state.saturation, b: state.brightness, a: alpha)
    }
    
    private func onChange(s: Double, b: Double, a: Double) {
        let h = state.hue
        let curve = curve
        
        let node = curve
            .nodeForHue(hue: h)
            .doCopy(h: h, s: s, b: b, a: a)
        if curve.nodes.count == 0 {
            curve.nodes = [node]
        } else if let idx = curve.nodes.firstIndex(where: { $0.h == h }) {
            curve.nodes[idx] = node
        } else if let idx = curve.nodes.firstIndex(where: { $0.h >= h }) {
            curve.nodes.insert(node, at: idx)
        } else {
            curve.nodes.append(node)
        }
        self.curve = curve
        
        state = stateFrom(hue: h, curve: curve)
    }
    
    func onPreviousPressed() {
        guard curve.nodes.count > 0,
              let node = curve.nodes.first(where: { $0.h < state.hue }) ?? curve.nodes.last else { return }
        state = stateFrom(hue: node.h, curve: curve)
    }
    
    func onNextPressed() {
        guard curve.nodes.count > 0,
              let node = curve.nodes.last(where: { state.hue < $0.h }) ?? curve.nodes.first else { return }
        state = stateFrom(hue: node.h, curve: curve)
    }
    
    func onDeletePressed() {
        guard curve.nodes.count > 0,
              let idx = curve.nodes.firstIndex(where: { state.hue == $0.h }) else { return }
        curve.nodes.remove(at: idx)
        state = stateFrom(hue: state.hue, curve: curve)
    }
    
}

private let colorStepCount = 32
private let steps = (0..<colorStepCount).map { Double($0) / Double(colorStepCount) }

private func stateFrom(hue: Double, curve: ColorCurve) -> ColorCurveViewModel.State {
    let node = curve.nodeForHue(hue: hue)
    
    let isNode = curve.nodes.contains(where: { $0.h == hue })
    let navEnabled = curve.nodes.count > 1 || curve.nodes.count == 1 && !isNode
    
    let pHue = steps.map { curve.nodeForHue(hue: 360.0 * $0).toColor }
    let (pSat, pBri, pAlp) = steps.reduce(into: ([Color](), [Color](), [Color]())) { result, step in
        result.0.append(node.doCopy(h: node.h, s: step, b: node.b, a: node.a).toColor)
        result.1.append(node.doCopy(h: node.h, s: node.s, b: step, a: node.a).toColor)
        result.2.append(node.doCopy(h: node.h, s: node.s, b: node.b, a: step).toColor)
    }
    
    return ColorCurveViewModel.State(
        hue: hue,
        saturation: node.s,
        brightness: node.b,
        alpha: node.a,
        previousEnabled: navEnabled,
        nextEnabled: navEnabled,
        deleteEnabled: isNode,
        color: node.toColor,
        possibleHueColors: pHue,
        possibleSatColors: pSat,
        possibleBriColors: pBri,
        possibleAlphaColors: pAlp)
}
