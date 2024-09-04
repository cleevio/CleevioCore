//
//  ActivityIndicator.swift
//  Test
//
//  Created by Daniel Fernandez Yopla on 07.01.2022.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
open class ActivityIndicator: @unchecked Sendable {
    private struct ActivityToken<Source: Publisher> {
        let source: Source
        let beginAction: () -> Void
        let finishAction: () -> Void

        func asPublisher() -> AnyPublisher<Source.Output, Source.Failure> {
            source.handleEvents(receiveCompletion: { _ in
                finishAction()
            }, receiveCancel: {
                finishAction()
            }, receiveRequest: { _ in
                beginAction()
            }).eraseToAnyPublisher()

        }
    }

    @Published private var relay = 0
    private let lock = NSRecursiveLock()

    open var loading: AnyPublisher<Bool, Never> {
        $relay.map { $0 > 0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    @inlinable
    public init() {}

    open func trackActivityOfPublisher<Source: Publisher>(source: Source) -> AnyPublisher<Source.Output, Source.Failure> {
        ActivityToken(source: source) {
            self.increment()
        } finishAction: {
            self.decrement()
        }.asPublisher()

    }

    private func increment() {
        lock.lock()
        relay += 1
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        relay -= 1
        lock.unlock()
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public extension Publisher {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> AnyPublisher<Self.Output, Self.Failure> {
        activityIndicator.trackActivityOfPublisher(source: self)
    }
}
