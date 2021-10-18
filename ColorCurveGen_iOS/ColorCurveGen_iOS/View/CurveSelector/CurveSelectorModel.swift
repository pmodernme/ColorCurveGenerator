//
//  CurveSelectorModel.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

final class CurveSelectorModel: ObservableObject, CurveSelectorModelStateProtocol {
    
    init(database: Database) {
//        collect(database.curves)
//            .completeOnFailure()
//            .map({ curves in
//                CurveSelectorState(data: curves.map { curve in
//                    guard let id = curve.id?.int64Value else { return nil }
//                    return CurveSelectorItem(colors: curve.asColorSpectrum(), id: id, isDark: curve.isDark, name: curve.name)
//                })
//            })
//            .sink { [weak self] curves in
//                print("Received \(curves.count) curves")
//            }
//            .store(in: &items)
    }
    
    @Published var state = CurveSelectorState(data: [])
    
    private var items: [CurveSelectorItem] {
        set {
            state = CurveSelectorState(data: newValue)
        }
        get {
            state.data
        }
    }
}

extension CurveSelectorModel: CurveSelectorModelActionsProtocol { }
