//
//  ViewModelType.swift
//  CleevioRoutersExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public protocol ViewModelType: ObservableObject {
    associatedtype ActionType
    associatedtype RouteType
    
    var action: ActionSubject<ActionType> { get}
    var route: CoordinatingSubject<RouteType> { get }

    var primaryActivity: Activity { get }
}

@available(iOS 13.0, *)
public extension ViewModelType {
    func send(action: ActionType) -> Void {
        self.action.send(action)
    }
}
