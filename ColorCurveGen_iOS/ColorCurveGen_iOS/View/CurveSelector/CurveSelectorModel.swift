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
        subscription = CurvePublisher(database: database)
            .map { curves in
                CurveSelectorState(data: curves.compactMap { curve in
                    guard let id = curve.id?.int64Value else { return nil }
                    return CurveSelectorItem(colors: curve.asColorSpectrum(), id: id, isDark: curve.isDark, name: curve.name)
                })
            }
            .assign(to: \.state, on: self)
    }
    
    @Published var state = CurveSelectorState(data: [])
    private var subscription: AnyCancellable?
}

private struct CurvePublisher: Publisher {
    typealias Output = [NamedColorCurve]
    typealias Failure = Never
    
    private let database: Database
    init(database: Database) {
        self.database = database
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, [NamedColorCurve] == S.Input {
        
    }
    
    final class CurveSubscription<S: Subscriber>: Subscription where S.Input == [NamedColorCurve], S.Failure == Failure {
        private var subscriber: S?
        private var job: Kotlinx_coroutines_coreJob? = nil
        
        private let database: Database
        
        init(database: Database, subscriber: S) {
            self.database = database
            self.subscriber = subscriber
            
            job = database.iosPollCurves.subscribe(
                scope: database.iosScope,
                onEach: { _ = subscriber.receive($0 as! [NamedColorCurve]) },
                onComplete: { subscriber.receive(completion: .finished)},
                onThrow: { error in debugPrint(error) }
            )
        }
        
        func cancel() {
            subscriber = nil
            job?.cancel(cause: nil)
        }
        
        func request(_ demand: Subscribers.Demand) {}
    }
}

extension CurveSelectorModel: CurveSelectorModelActionsProtocol { }
