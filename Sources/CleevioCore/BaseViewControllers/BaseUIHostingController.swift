//
//  BaseUIHostingController.swift
//  
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import SwiftUI

@available(iOS 13.0, *)
open class BaseUIHostingController<RootView: View>: UIHostingController<RootView>, PopHandler {
    public let dismissPublisher: ActionSubject<Void> = .init()

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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if DEBUG
        dchCheckDeallocation()
        #endif
    }
}
