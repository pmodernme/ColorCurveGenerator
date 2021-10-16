//
//  ColorCurveModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

protocol CurveEditorModelStateProtocol {
    var state: CurveEditorState { get }
}

protocol CurveEditorModelActionsProtocol: AnyObject {
    func render(hue: Double)
    func render(s: Double?, b: Double?, a: Double?)
    func renderNextHue()
    func renderPreviousHue()
    func deleteHue()
}

struct CurveEditorState {
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
