//
//  CancelBag.swift
//  CleevioRoutersExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
open class CancelBag {
    @usableFromInline
    var subscriptions = Cancellables()
    @usableFromInline
    let lock = NSLock()

    @inlinable
    public init() {}

    @inlinable
    open func cancel() {
        withLock {
            subscriptions.forEach { $0.cancel() }
            subscriptions.removeAll()
        }
    }

    @inlinable
    open func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        withLock {
            subscriptions.formUnion(cancellables())
        }
    }

    @inlinable
    open func register(subscription: AnyCancellable) {
        withLock {
            subscriptions.insert(subscription)
        }
    }

    @resultBuilder
    public struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }

    @inlinable
    func withLock(_ action: () -> Void) {
        lock.lock()

        defer {
            lock.unlock()
        }

        action()
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public extension AnyCancellable {
    @inlinable
    func store(in cancelBag: CancelBag) {
        cancelBag.register(subscription: self)
    }
}
