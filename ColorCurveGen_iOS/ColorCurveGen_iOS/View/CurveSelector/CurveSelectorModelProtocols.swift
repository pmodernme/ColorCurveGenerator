//
//  CurveSelectorModelProtocols.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

protocol CurveSelectorModelStateProtocol {
    var state: CurveSelectorState { get }
}

protocol CurveSelectorModelActionsProtocol {
}

struct CurveSelectorState {
    let data: [CurveSelectorItem]
}

struct CurveSelectorItem: Identifiable {
    var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    var id: Int64 = .random(in: 0...Int64.max)
    var isDark: Bool = false
    var name: String = "Curve Name"
}
