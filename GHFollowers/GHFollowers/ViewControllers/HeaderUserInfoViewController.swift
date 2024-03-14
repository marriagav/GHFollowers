//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class HeaderUserInfoViewController: UIViewController {
    var user: User?
    var userCardView: UserCardView?

    init(user: User? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUserCard()
    }

    func configureUserCard() {
        userCardView = UserCardView(frame: view.bounds, user: user)
        guard let userCardView = userCardView else { return }
        view.addSubview(userCardView)
        NSLayoutConstraint.activate([
            userCardView.topAnchor.constraint(equalTo: view.topAnchor),
            userCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userCardView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}
