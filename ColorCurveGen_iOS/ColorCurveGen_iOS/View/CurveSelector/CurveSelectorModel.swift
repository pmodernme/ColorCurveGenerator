//
//  CurveSelectorModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation

final class CurveSelectorModel: ObservableObject, CurveSelectorModelStateProtocol {
    var state: CurveSelectorState
    
    init(state: CurveSelectorState) {
        self.state = state
    }
}
