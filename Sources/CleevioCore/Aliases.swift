//
//  Aliases.swift
//  Pods
//
//  Created by Adam Salih on 05.02.2022.
//

import Combine

@available(iOS 13.0, macOS 10.15, *)
public typealias CoordinatingResult<T> = AnyPublisher<T, Never>
@available(iOS 13.0, macOS 10.15, *)
public typealias CoordinatingSubject<T> = PassthroughSubject<T, Never>
@available(iOS 13.0, macOS 10.15, *)
public typealias ActionSubject<T> = PassthroughSubject<T, Never>
@available(iOS 13.0, macOS 10.15, *)
public typealias Cancellables = Set<AnyCancellable>
