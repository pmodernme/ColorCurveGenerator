//
//  CurveEditorModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Shared
import SwiftUI

final class CurveEditorModel: ObservableObject, CurveEditorModelStateProtocol {
    internal init(curve: ColorCurve) {
        self.curve = curve
        state = stateFrom(hue: 0.0, curve: curve)
    }
    
    @Published var state: CurveEditorState
    
    private var curve: ColorCurve
}

extension CurveEditorModel: CurveEditorModelActionsProtocol {
    func render(hue: Double) {
        state = stateFrom(hue: hue, curve: curve)
    }
    
    func render(s: Double?, b: Double?, a: Double?) {
        let h = state.hue
        let curve = curve
        
        let node = curve
            .nodeForHue(hue: h)
            .doCopy(h: h, s: s ?? state.saturation, b: b ?? state.brightness, a: a ?? state.alpha)
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
    
    func renderNextHue() {
        guard curve.nodes.count > 0,
              let node = curve.nodes.first(where: { state.hue < $0.h }) ?? curve.nodes.first else { return }
        state = stateFrom(hue: node.h, curve: curve)
    }
    
    func renderPreviousHue() {
        guard curve.nodes.count > 0,
              let node = curve.nodes.last(where: { $0.h < state.hue }) ?? curve.nodes.last else { return }
        state = stateFrom(hue: node.h, curve: curve)
    }
    
    func deleteHue() {
        guard curve.nodes.count > 0,
              let idx = curve.nodes.firstIndex(where: { state.hue == $0.h }) else { return }
        curve.nodes.remove(at: idx)
        state = stateFrom(hue: state.hue, curve: curve)
    }
}

private func stateFrom(hue: Double, curve: ColorCurve) -> CurveEditorState {
    let node = curve.nodeForHue(hue: hue)
    
    let isNode = curve.nodes.contains(where: { $0.h == hue })
    let navEnabled = curve.nodes.count > 1 || curve.nodes.count == 1 && !isNode
    
    return CurveEditorState(
        hue: hue,
        saturation: node.s,
        brightness: node.b,
        alpha: node.a,
        previousEnabled: navEnabled,
        nextEnabled: navEnabled,
        deleteEnabled: isNode,
        color: node.toColor,
        possibleHueColors: curve.asColorSpectrum(),
        possibleSatColors: node.saturationSpectrum().colors,
        possibleBriColors: node.brightnessSpectrum().colors,
        possibleAlphaColors: node.alphaSpectrum().colors)
}
