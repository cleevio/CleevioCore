//
//  AssociatedObjectHelper.swift
//  
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import Foundation

/// Set associated object to object. Its useful on storing values in extensions.
public func setAssociatedObject<ValueType, Object, PointerType>(base: Object, key: UnsafePointer<PointerType>, value: ValueType?) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

/// Remove associated object from object.
public func removeAllAssociatedObjects<Object>(base: Object) {
    objc_removeAssociatedObjects(base)
}
