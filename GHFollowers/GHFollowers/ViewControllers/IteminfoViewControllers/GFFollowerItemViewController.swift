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
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImage: .people)
    }

    override func actionButtonTapped() {
        delegate?.didTapGetFollowers()
    }
}
