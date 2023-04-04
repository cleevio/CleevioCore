//
//  Coordinator.swift
//
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import Foundation

#if os(iOS)
import UIKit
public typealias PlatformViewController = UIViewController
#elseif os(macOS)
import AppKit
public typealias PlatformViewController = NSViewController
#endif

/// The `CoordinatorEventDelegate` protocol defines a method that is called when a coordinator is deallocated.
public protocol CoordinatorEventDelegate: AnyObject {
    /// Notifies the delegate that the specified coordinator has been deallocated.
    ///
    /// - Parameter coordinator: The coordinator that has been deallocated.
    func onDeinit(of coordinator: Coordinator)
}

/// The `Coordinator` class is a base class for coordinator objects. It provides methods for managing child coordinators.
open class Coordinator: CoordinatorEventDelegate {
    /// Dictionary that stores the child coordinators.
    public final var childCoordinators: [HashableType<Coordinator>: Coordinator] = [:]

    private var id = UUID()

    /// The view controller that this coordinator manages. Lifetime of this Coordinator is tied on lifetime of the ViewController.
    public final weak var viewController: PlatformViewController? {
        willSet {
            guard let newValue else { return }
            setAssociatedObject(base: newValue, key: &id, value: self)
        }
    }

    private weak var delegate: CoordinatorEventDelegate?

    public init() { }

    deinit {
        delegate?.onDeinit(of: self)
    }

    /// Sets a delegate of type CoordinatorEventDelegate that is called when the coordinator is deallocated.
    open func setDelegate(_ delegate: some CoordinatorEventDelegate) {
        self.delegate = delegate
    }

    /// Returns a child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to return.
    /// - Returns: The child coordinator of the specified type, or `nil` if it doesn't exist.
    @inlinable
    public final func childCoordinator<T: Coordinator>(of type: T.Type = T.self) -> T? {
        return childCoordinators[type] as? T
    }

    /// Removes the child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to remove.
    @inlinable
    public final func removeChildCoordinator<T: Coordinator>(of type: T.Type = T.self) {
        childCoordinators[type] = nil
    }

    /// Removes the specified child coordinator.
    ///
    /// - Parameter coordinator: The child coordinator to remove.
    @inlinable
    public final func removeChildCoordinator(_ coordinator: some Coordinator) {
        removeChildCoordinator(of: type(of: coordinator))
    }

    /// Starts the coordinator. Subclasses must provide an implementation of this method.
    open func start() {
        fatalError("Implementation of start is required")
    }

    open func onDeinit(of coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}
