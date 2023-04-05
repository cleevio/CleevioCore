//
//  BaseUIHostingController.swift
//  
//
//  Created by Lukáš Valenta on 31.03.2023.
//

#if os(iOS)
import SwiftUI

@available(iOS 13.0, *)
open class BaseUIHostingController<RootView: View>: UIHostingController<RootView>, DismissHandler {
    public var dismissPublisher: ActionSubject<Void> = .init()
    
    public override init(rootView: RootView) {
        super.init(rootView: rootView)
    }

    @MainActor required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
#endif
