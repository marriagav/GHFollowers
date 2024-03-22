//
//  GFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 18/03/24.
//

import UIKit

protocol GFFollowerItemViewControllerDelegate: AnyObject {
    func didTapGetFollowers()
}

class GFFollowerItemViewController: GFItemInfoViewController {
    weak var delegate: GFFollowerItemViewControllerDelegate?

    init(user: User?, delegate: GFFollowerItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user?.followers ?? 0)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user?.following ?? 0)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

    override func actionButtonTapped() {
        delegate?.didTapGetFollowers()
    }
}
