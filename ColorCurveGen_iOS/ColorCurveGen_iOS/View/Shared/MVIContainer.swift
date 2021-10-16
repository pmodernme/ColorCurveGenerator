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

final class MVIContainer<Model, Intent>: ObservableObject {
    
    init(model: Model, intent: Intent, modelChangePublisher: ObjectWillChangePublisher? = nil) {
        self.intent = intent
        self.model = model
        
        if let modelChangePublisher = modelChangePublisher {
            modelChangePublisher
                .receive(on: RunLoop.main)
                .sink(receiveValue: objectWillChange.send)
                .store(in: &cancellable)
        }
    }
    
    let intent: Intent
    
    @Published var model: Model
    
    private var cancellable: Set<AnyCancellable> = []
}
