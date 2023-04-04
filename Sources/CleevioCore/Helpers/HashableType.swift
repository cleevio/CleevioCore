//
//  HashableType.swift
//
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import Foundation

/// A `HashableType` is a hashable wrapper for a metatype value.
public struct HashableType<T> {
    /// The base type for the `HashableType` wrapper.
    public let base: T.Type
    
    /// Creates a new `HashableType` wrapper with the specified base type.
    ///
    /// - Parameter base: The base type for the `HashableType` wrapper.
    public init(_ base: T.Type) {
        self.base = base
    }
}

extension HashableType: Hashable {
    public static func == (lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.base == rhs.base
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(base))
    }
}

public extension Dictionary {
    /// Accesses the value associated with the specified key.
    ///
    /// - Parameter key: The type of the key.
    /// - Returns: The value associated with `key`, or `nil` if `key` is not in the dictionary.
    subscript<T>(key: T.Type) -> Value? where Key == HashableType<T> {
        get { return self[HashableType(key)] }
        set { self[HashableType(key)] = newValue }
    }
}
