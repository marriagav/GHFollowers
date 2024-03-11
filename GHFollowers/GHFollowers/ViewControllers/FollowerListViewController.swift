//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 08/03/24.
//

import UIKit

class FollowerListViewController: UIViewController {
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        // With callback
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case let .success(followers):
                print(followers)
            case let .failure(error):
                self.presentGFAlertOnMainThread(
                    title: "Bad stuff happened",
                    message: error.localizedDescription,
                    buttonTitle: "Ok"
                )
            }
        }

        // With async/await
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: 1)
                print(followers)
            } catch {
                presentGFAlertOnMainThread(
                    title: "Bad stuff happened",
                    message: error.localizedDescription,
                    buttonTitle: "Ok"
                )
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
