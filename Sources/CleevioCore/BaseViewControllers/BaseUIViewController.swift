//
//  BaseUIViewController.swift
//  
//
//  Created by Lukáš Valenta on 31.03.2023.
//

#if os(iOS)
import UIKit

@available(iOS 13.0, *)
@MainActor
open class BaseUIViewController: UIViewController, DismissHandler {
    public var dismissPublisher: ActionSubject<Void> = .init()

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        dismissIfNeeded(parent: parent)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if DEBUG
        dchCheckDeallocation()
        #endif
    }
}

@available(iOS 13.0, *)
extension DismissHandler where Self: UIViewController {
    @MainActor
    func dismissIfNeeded(parent: UIViewController?) {
        if parent == nil {
            dismissPublisher.send()
            dismissPublisher.send(completion: .finished)
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
extension UIViewController {
    @MainActor
    public func dchCheckDeallocation(afterDelay delay: TimeInterval = 2.0) {
        let rootParentViewController = dchRootParentViewController

        // It can in weird constellations crash when tabbar is hiding
        if rootParentViewController as? UITabBarController != nil {
            return
        }

        // We don't check `isBeingDismissed` simply on this view controller because it's common
        // to wrap a view controller in another view controller (e.g. in UINavigationController)
        // and present the wrapping view controller instead.
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let typeOf = type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                assert(self == nil, "\(typeOf) not deallocated after being \(disappearanceSource)")
            })
        }
    }

    public var dchRootParentViewController: UIViewController {
        var root = self
        while let parent = root.parent {
            root = parent
        }
        return root
    }
}
#endif
#endif
