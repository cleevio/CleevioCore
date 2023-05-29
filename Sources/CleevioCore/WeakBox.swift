//
//  WeakBox.swift
//  
//
//  Created by Lukáš Valenta on 05.04.2023.
//

import Foundation

/**
 A box that holds a weak reference to an object of type `A`.
 */
@dynamicMemberLookup
public final class WeakBox<Object: AnyObject> {
    
    /// The weakly-held object.
    private(set) public weak var unbox: Object?
    
    /**
     Initializes a new instance of `WeakBox` with the given object.
     
     - Parameter value: The object to store in the box.
     */
    public init(_ value: Object) {
        unbox = value
    }
    
    /**
     Provides access to the properties of the weakly-held object using a key path.
     
     - Parameter keyPath: The key path to the desired property.
     - Returns: The value of the property if the weakly-held object exists, otherwise `nil`.
     */
    @inlinable
    public subscript<T>(dynamicMember keyPath: KeyPath<Object, T>) -> T? {
        unbox?[keyPath: keyPath]
    }
}

extension WeakBox: @unchecked Sendable where Object: Sendable { }

/**
 An array-like collection that holds weak references to objects of type `Element`.
 */
public struct WeakArray<Element: AnyObject> {
    
    /// The items in the array.
    @usableFromInline
    var items: [WeakBox<Element>] = []
    
    /**
     Initializes a new instance of `WeakArray` with the given elements.
     
     - Parameter elements: The elements to store in the array.
     */
    @inlinable
    public init(_ elements: [Element]) {
        items = elements.map(WeakBox.init)
    }
    
    /**
     Initializes a new, empty instance of `WeakArray`.
     */
    @inlinable
    public init() {}
}

extension WeakArray: Collection {
    
    /// The index of the first item in the array.
    @inlinable
    public var startIndex: Int { return items.startIndex }
    
    /// The index one past the last item in the array.
    @inlinable
    public var endIndex: Int { return items.endIndex }
    
    /**
     Accesses the item at the given index.
     
     - Parameter index: The index of the desired item.
     - Returns: The item at the given index, if it exists, otherwise `nil`.
     */
    @inlinable
    public subscript(_ index: Int) -> Element? {
        return items[index].unbox
    }
    
    /**
     Advances the given index by one.
     
     - Parameter idx: The index to advance.
     - Returns: The index one past the given index.
     */
    @inlinable
    public func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
    
    /**
     Appends an element to the end of the array.
     
     - Parameter element: The element to append.
     */
    @inlinable
    public mutating func append(_ element: Element) {
        items.append(WeakBox(element))
    }
    
    /**
     Removes all elements from the array.
     */
    @inlinable
    public mutating func removeAll() {
        items.removeAll()
    }
}
