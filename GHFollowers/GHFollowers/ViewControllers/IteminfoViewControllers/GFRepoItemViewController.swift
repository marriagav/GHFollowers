//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 17/03/24.
//

import UIKit

protocol GFRepoItemInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile()
}

class GFRepoItemViewController: GFItemInfoViewController {
    weak var delegate: GFRepoItemInfoViewControllerDelegate?

    init(user: User?, delegate: GFRepoItemInfoViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user?.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user?.publicGists ?? 0)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }

    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile()
    }
}
