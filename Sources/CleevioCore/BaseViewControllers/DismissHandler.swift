//
//  DismissHandler.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
public protocol DismissHandler {
    var dismissPublisher: ActionSubject<Void> { get }
}

@available(iOS 13.0, macOS 10.15, *)
public typealias PopHandler = DismissHandler
