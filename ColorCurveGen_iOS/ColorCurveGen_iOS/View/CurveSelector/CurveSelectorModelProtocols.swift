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
    
    func editorViewModel(for item: CurveSelectorItem) -> MVIContainer<CurveEditorModelStateProtocol, CurveEditorIntentProtocol>
}

protocol CurveSelectorModelActionsProtocol {
}

struct CurveSelectorState {
    let data: [CurveSelectorItem]
}

struct CurveSelectorItem: Identifiable {
    var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    var id: String = UUID().uuidString
    var isDark: Bool = false
    var name: String = "Curve Name"
}
