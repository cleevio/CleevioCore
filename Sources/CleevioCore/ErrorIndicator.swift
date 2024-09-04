//
//  ErrorIndicator.swift
//  Test
//
//  Created by Daniel Fernandez Yopla on 07.01.2022.
//

import Foundation
import Combine

/**
 Enables monitoring error of sequence computation.
 */
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
open class ErrorIndicator: @unchecked Sendable {
    private struct ActivityToken<Source: Publisher> {
        let source: Source
        let errorAction: (Source.Failure) -> Void

        func asPublisher() -> AnyPublisher<Source.Output, Never> {
            source.handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    errorAction(error)
                }
            })
            .catch { _ in Empty(completeImmediately: true) }
            .eraseToAnyPublisher()
        }
    }

    @Published private var relay: Error?
    private let lock = NSRecursiveLock()

    open var errors: AnyPublisher<Error, Never> {
        $relay.compactMap { $0 }.eraseToAnyPublisher()
    }

    public init() {}

    open func trackErrorOfPublisher<Source: Publisher>(source: Source) -> AnyPublisher<Source.Output, Never> {
        ActivityToken(source: source) { error in
            self.lock.lock()
            self.relay = error
            self.lock.unlock()
        }.asPublisher()
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public extension Publisher {
    func trackError(_ errorIndicator: ErrorIndicator) -> AnyPublisher<Self.Output, Never> {
        errorIndicator.trackErrorOfPublisher(source: self)
    }
}
