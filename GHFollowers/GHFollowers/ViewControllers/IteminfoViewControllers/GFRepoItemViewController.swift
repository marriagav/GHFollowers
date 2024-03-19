//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 17/03/24.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user?.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user?.publicGists ?? 0)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
}

#Preview {
    let preview = GFRepoItemViewController(user: User(
        login: "test",
        avatarUrl: "test",
        publicRepos: 2,
        publicGists: 3,
        htmlUrl: "test",
        followers: 4,
        following: 6,
        createdAt: "now"
    ))
    return preview
}
