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
    internal init(curve: ColorCurve, database: Database? = nil) {
        self.curve = curve
        self.database = database
        state = stateFrom(hue: 0.0, curve: curve)
        if let curve = curve as? NamedColorCurve {
            self.name = curve.name
            self.id = curve.id as? Int64
            self.isDark = curve.isDark
        } else {
            self.name = "New Curve"
            self.id = nil
        }
    }
    
    @Published var state: CurveEditorState
    @Published var name: String { didSet { if let curve = curve as? NamedColorCurve {
        self.curve = curve.doCopy(nodes: curve.nodes, name: name, id: curve.id, isDark: curve.isDark)
    }}}
    @Published var isDark: Bool = false { didSet { if let curve = curve as? NamedColorCurve {
        self.curve = curve.doCopy(nodes: curve.nodes, name: curve.name, id: curve.id, isDark: isDark)
    }}}
    let id: Int64?
    
    private var curve: ColorCurve { didSet {
        saveUpdate()
    }}
    
    private let database: Database?
    
    private func _saveUpdate() {
        guard let curve = curve as? NamedColorCurve else { return }
        database?.updateCurve(id: curve.id as! Int64, name: name, isDark: isDark, nodes: curve.nodes)
    }
    private lazy var saveUpdate = debounce(delay: .milliseconds(300)) { [weak self] in
        self?._saveUpdate()
    }
}

extension CurveEditorModel: CurveEditorModelActionsProtocol {
    
    func saveNameChange() {
        if let id = id, let database = database {
            database.updateCurve(id: id, name: name, isDark: isDark, nodes: curve.nodes)
        }
    }
    
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
        let curve = curve
        curve.nodes.remove(at: idx)
        self.curve = curve
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
