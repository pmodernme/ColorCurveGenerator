//
//  CurveSelectorViewModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI
import Shared

protocol CurveSelectorViewModelProtocol {
    var state: CurveSelectorState { get }
}

final class CurveSelectorViewModel: ObservableObject & CurveSelectorViewModelProtocol {    
    
    init(state: CurveSelectorState) {
        self.state = state
    }
    
    @Published var state: CurveSelectorState
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
