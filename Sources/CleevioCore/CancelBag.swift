//
//  CancelBag.swift
//  CleevioRoutersExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Combine

@available(iOS 13.0, macOS 10.15, *)
open class CancelBag {
    private var subscriptions = Cancellables()

    public init() {}

    open func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    open func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }

    open func register(subscription: AnyCancellable) {
        subscriptions.insert(subscription)
    }

    @resultBuilder
    public struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
public extension AnyCancellable {
    @inlinable
    func store(in cancelBag: CancelBag) {
        cancelBag.register(subscription: self)
    }
}
