//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var follower: Follower?
    var user: User?
    var userCardView: UserCardView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureDoneButton()
        Task {
            await getUser()
            userCardView = UserCardView(frame: .zero)
            userCardView?.user = user
            guard let userCardView = userCardView else { return }
            userCardView.configureCard()
            view.addSubview(userCardView)
            NSLayoutConstraint.activate([
                userCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                userCardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                userCardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])
        }
    }

    @objc
    func dismissVC() {
        dismiss(animated: true)
    }

    func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }

    func getUser() async {
        do {
            guard let follower = follower else { return }
            user = try await NetworkManager.shared.getUser(for: follower.login)
        } catch {
            presentGFAlertOnMainThread(
                title: "Bad stuff happened",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }
}
