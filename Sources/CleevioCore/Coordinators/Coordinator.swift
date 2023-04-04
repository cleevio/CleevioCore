//
//  Coordinator.swift
//  CleevioUIExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
public protocol Coordinator {
    associatedtype CoordinationResult

    var identifier: UUID { get }

    func start() -> CoordinatingResult<CoordinationResult>
}
