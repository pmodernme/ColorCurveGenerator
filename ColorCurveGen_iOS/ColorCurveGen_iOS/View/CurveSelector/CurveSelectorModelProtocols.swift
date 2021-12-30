//
//  CurveSelectorModelProtocols.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI
import Shared

protocol CurveSelectorModelStateProtocol {
    var state: CurveSelectorState { get }
    func editorViewModel(for item: CurveSelectorItem) -> MVIContainer<CurveEditorModelStateProtocol, CurveEditorIntentProtocol>
}

protocol CurveSelectorModelActionsProtocol: AnyObject {
    func insertNewCurve(name: String, isDark: Bool)
}

struct CurveSelectorState {
    let data: [CurveSelectorItem]
}

struct CurveSelectorItem: Identifiable {
    var curve: ColorCurve = BasicColorCurve(nodes: (0..<8).map { ColorCurveNode(h: (Double($0)/8.0)*360.0, s: 1, b: 1, a: 1) })
    var id: Int64 = .random(in: 0...Int64.max)
    var isDark: Bool = false
    var name: String = "Curve Name"
    
    var colors: [Color] { curve.asColorSpectrum() }
}
