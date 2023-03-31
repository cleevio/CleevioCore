//
//  BaseController.swift
//  Cleevio
//
//  Created by Thành Đỗ Long on 12.01.2022.
//

import SwiftUI
import Combine

public protocol LoaderUIViewType: UIView {
    func startLoading()
    func stopLoading()
}

public protocol ErrorHandlerType {
    func presentError(in controller: UIViewController?, withTitle title: String?, onDismiss: @escaping () -> Void)
}

@available(iOS, introduced: 13.0, deprecated)
open class BaseViewController<RootView: View>: UIHostingController<RootView>, PopHandler {
    @Published open var error: Error?
    @Published open var isLoading = false

    open var cancelBag: CancelBag = .init()
    public let dismissPublisher: ActionSubject<Void> = .init()

    private var loader: LoaderUIViewType
    private var errorHandler: ErrorHandlerType

    public init(rootView: RootView, loader: LoaderUIViewType = LoadingView(), errorHandler: ErrorHandlerType = ErrorHandler()) {
        self.loader = loader
        self.errorHandler = errorHandler
        super.init(rootView: rootView)
        setupErrorBinding()
        setupLoadingBinding()
    }

    @MainActor required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            dismissPublisher.send()
            dismissPublisher.send(completion: .finished)
        }
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

    private func setupErrorBinding() {
        $error
            .filter { $0 != nil }
            .sink { [weak self] error in
                self?.errorHandler.presentError(in: self, withTitle: error?.localizedDescription) {
                    self?.error = nil
                }
            }
            .store(in: cancelBag)
        }

    private func setupLoadingBinding() {
        view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.topAnchor.constraint(equalTo: view.topAnchor),
            loader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        $isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.loader.startLoading() : self?.loader.stopLoading()
            }
            .store(in: cancelBag)
    }
}

@available(iOS 13.0, *)
extension BaseViewController {
    open class LoadingView: UIView, LoaderUIViewType {
        public struct Appearance {
            var cornerRadius: CGFloat = 8
            var dimmingViewAlpha: CGFloat = 0.25
            var squareWidth: CGFloat = 60

            public init() {}

            public init(cornerRadius: CGFloat = 8, dimmingViewAlpha: CGFloat = 0.25, squareWidth: CGFloat = 60) {
                self.cornerRadius = cornerRadius
                self.dimmingViewAlpha = dimmingViewAlpha
                self.squareWidth = squareWidth
            }
        }

        private lazy var dimmingView: UIView = {
            let dimmingView = UIView()
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            dimmingView.backgroundColor = .black
            dimmingView.alpha = appearance.dimmingViewAlpha
            return dimmingView
        }()

        private lazy var loadingView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = appearance.cornerRadius
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var activityIndicator: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView()
            activity.translatesAutoresizingMaskIntoConstraints = false
            return activity
        }()

        private let appearance: Appearance

        public init(appearance: Appearance = Appearance()) {
            self.appearance = appearance
            super.init(frame: .zero)

            addSubview(dimmingView)
            NSLayoutConstraint.activate([
                dimmingView.topAnchor.constraint(equalTo: topAnchor),
                dimmingView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: trailingAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            addSubview(loadingView)
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loadingView.heightAnchor.constraint(equalToConstant: appearance.squareWidth),
                loadingView.widthAnchor.constraint(equalTo: loadingView.heightAnchor)
            ])

            loadingView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        open func startLoading() {
            activityIndicator.startAnimating()
            isHidden = false
        }

        open func stopLoading() {
            activityIndicator.stopAnimating()
            isHidden = true
        }
    }
}

public class ErrorHandler: ErrorHandlerType {
    private var dismissButtonText: String

    public init(dismissButtonText: String = "Ok") {
        self.dismissButtonText = dismissButtonText
    }

    public func presentError(in controller: UIViewController?, withTitle title: String?, onDismiss: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissButtonText, style: .cancel) { _ in
            onDismiss()
        }
        alertController.addAction(dismissAction)
        DispatchQueue.main.async {
            controller?.present(alertController, animated: true)
        }
    }
}
