//
//  Activity.swift
//  pilulka
//
//  Created by Adam Salih on 11.10.2021.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public struct Activity: Sendable {
    public let indicator: ActivityIndicator
    public let error: ErrorIndicator

    @inlinable
    public init(indicator: ActivityIndicator? = nil, error: ErrorIndicator? = nil) {
        self.indicator = indicator ?? .init()
        self.error = error ?? .init()
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0,*)
public extension Publisher {
    func track(activity: Activity) -> AnyPublisher<Output, Never> {
        self
            .trackActivity(activity.indicator)
            .trackError(activity.error)
    }
}
