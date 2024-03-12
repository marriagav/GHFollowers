//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 11/03/24.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {
        usernameLabel.text = follower.login
        Task {
            await avatarImageView.downloadImage(from: follower.avatarUrl)
        }
    }

    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

#Preview {
    let cell = FollowerCell(frame: .zero)
    cell.set(follower: Follower(login: "marriagav", avatarUrl: "www.google.com"))
    return cell
}
