//
//  Color+ColorCurve.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 9/28/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI
import Shared

extension ColorCurveNode {
    var toColor: Color {
        return Color(hue: h/360.0, saturation: s, brightness: b, opacity: a)
    }
}

extension ColorCurve {
    func colorAtHue(_ hue: Double) -> Color {
        return nodeForHue(hue: hue).toColor
    }
    
    func asColorSpectrum(steps numberOfSteps: Int = 32) -> [Color] {
        return asSpectrum().map { $0.toColor }
    }
}

extension Array where Element: ColorCurveNode {
    var colors: [Color] { map { $0.toColor }}
}
