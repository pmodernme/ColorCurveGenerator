//
//  ColorCurveIntent.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation

protocol CurveEditorIntentProtocol {
    func onHueChange(_ hue: Double)
    func onSaturationChange(_ saturation: Double)
    func onBrightnessChange(_ brightness: Double)
    func onAlphaChange(_ alpha: Double)
    func onPreviousPressed()
    func onNextPressed()
    func onDeletePressed()
    func onNameChanged()
}
