//
//  UIViewController-Alert.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 09/03/24.
//

import SafariServices
import UIKit

extension UIViewController {
    @MainActor
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
