//
//  ColorCurveViewModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/15/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared
import SwiftUI

final class CurveEditorViewModel: ObservableObject {
    
    init(intent: CurveEditorIntentProtocol, model: CurveEditorModelStateProtocol) {
        self.intent = intent
        self.model = model
        
        if let model = model as? CurveEditorModel {
            model.objectWillChange
                .receive(on: RunLoop.main)
                .sink(receiveValue: objectWillChange.send)
                .store(in: &cancellable)
        }
    }
    
    let intent: CurveEditorIntentProtocol
    
    @Published var model: CurveEditorModelStateProtocol
    
    private var cancellable: Set<AnyCancellable> = []
}
