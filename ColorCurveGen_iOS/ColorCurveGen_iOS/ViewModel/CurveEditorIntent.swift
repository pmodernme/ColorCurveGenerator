//
//  CurveEditorIntent.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation

final class CurveEditorIntent: CurveEditorIntentProtocol {
    
    init(model: CurveEditorModelActionsProtocol) {
        self.model = model
    }
    
    func onHueChange(_ hue: Double) {
        model?.render(hue: hue)
    }
    
    func onSaturationChange(_ saturation: Double) {
        model?.render(s: saturation, b: nil, a: nil)
    }
    
    func onBrightnessChange(_ brightness: Double) {
        model?.render(s: nil, b: brightness, a: nil)
    }
    
    func onAlphaChange(_ alpha: Double) {
        model?.render(s: nil, b: nil, a: alpha)
    }
    
    func onPreviousPressed() {
        model?.renderPreviousHue()
    }
    
    func onNextPressed() {
        model?.renderNextHue()
    }
    
    func onDeletePressed() {
        model?.deleteHue()
    }
    
    private weak var model: CurveEditorModelActionsProtocol?
}
