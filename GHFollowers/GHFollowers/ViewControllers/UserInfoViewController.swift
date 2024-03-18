//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 13/03/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var follower: Follower?
    var user: User?
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()

    init(follower: Follower? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.follower = follower
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureDoneButton()
        layoutUI()
        Task {
            await getUser()
            add(childVC: HeaderUserInfoViewController(user: user), to: headerView)
        }
    }

    func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }

    @objc
    func dismissVC() {
        dismiss(animated: true)
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

    @MainActor
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    func layoutUI() {
        let itemViews = [headerView, itemViewOne, itemViewTwo]

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews.forEach { itemView in
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -padding
                )
            ])
        }

        // TODO: temp code
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemCyan

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.heightAnchor.constraint(equalToConstant: 170),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalTo: itemViewOne.heightAnchor)
        ])
    }
}
