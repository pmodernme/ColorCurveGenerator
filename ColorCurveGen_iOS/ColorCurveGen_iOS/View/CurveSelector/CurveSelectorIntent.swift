//
//  CurveSelectorIntent.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation

final class CurveSelectorIntent: CurveSelectorIntentProtocol {
    
    internal init(model: CurveSelectorModelActionsProtocol) {
        self.model = model
    }
    
    weak var model: CurveSelectorModelActionsProtocol?
    
    func onComposePressed() {
        
    }
}
