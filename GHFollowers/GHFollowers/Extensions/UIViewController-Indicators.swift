//
//  UIViewController-Alert.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 09/03/24.
//

import UIKit

private var containerView: UIView?

extension UIViewController {

    @MainActor
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }

    @MainActor
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        guard let containerView = containerView else { return }
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }

    @MainActor
    func dismissLoadingView() {
        if let containerView = containerView {
            containerView.removeFromSuperview()
        }
        containerView = nil
    }

    @MainActor
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
