//
//  Publisher+Failures.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/18/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

extension KotlinThrowable: Error { }

struct PublisherFailures {
    /**
         The action to invoke when a failure is dropped as the result of a `Publisher` returned by
         `Publisher.completeOnFailure()`.
         */
        static var willCompleteOnFailure: (Error, Callsite) -> Void = { error, callsite in
            if error is KotlinCancellationException {
                return
            }

            print("[ERROR] A publisher failed and was completed due to a call to `completeOnFailure()` \(callsite): \(error)")
        }
}

struct Callsite: CustomStringConvertible {
    let file: String
    let fileID: String
    let filePath: String
    let line: Int
    let column: Int
    let function: String
    let dsoHandle: UnsafeRawPointer

    var description: String {
        "in \(function) at \(filePath)#\(line):\(column)"
    }
}

extension Publisher {
    /**
     Ignores errors in the upstream publisher, emitting an empty sequence instead, and otherwise republishes all received input.
     You can hook into these failures by assigning a function to `PublisherHooks.willCompleteOnFailure`.
     */
    func completeOnFailure(
        file: String = #file,
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        dsoHandle: UnsafeRawPointer = #dsohandle)
    -> Publishers.Catch<Self, Empty<Output, Never>> {
        return `catch` { error in
            let callsite = Callsite(file: file, fileID: fileID, filePath: filePath, line: line, column: column, function: function, dsoHandle: dsoHandle)
            PublisherFailures.willCompleteOnFailure(error, callsite)
            return Empty(completeImmediately: true)
        }
    }
}
