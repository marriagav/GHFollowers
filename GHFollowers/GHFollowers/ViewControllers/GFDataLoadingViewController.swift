//
//  GFDataLoadingViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 21/03/24.
//

import UIKit

class GFDataLoadingViewController: UIViewController {
    private var containerView: UIView?

    @MainActor
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        guard let containerView else { return }
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
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }

    @MainActor
    func dismissLoadingView() {
        if let containerView {
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
