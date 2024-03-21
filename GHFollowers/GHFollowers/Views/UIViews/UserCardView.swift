//
//  UserCardView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class UserCardView: UIView {
    var user: User?
    let avatarImageView = GFAvatarImageView(frame: .zero)
    var usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    var nameLabel = GFSecondaryTitleLabel(frame: .zero)
    var locationLabel = GFIconLabel(
        label: GFSecondaryTitleLabel(frame: .zero),
        systemIcon: SFSymbols.location,
        textAlignment: .left
    )
    var bioLabel = GFBodyLabel(textAlignment: .left)

    init(frame: CGRect, user: User? = nil) {
        super.init(frame: frame)
        self.user = user
        translatesAutoresizingMaskIntoConstraints = false
        configureCard()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCard() {
        Task {
            await avatarImageView.downloadImage(from: user?.avatarUrl ?? "")
        }
        addSubviews(avatarImageView, usernameLabel, nameLabel, locationLabel, bioLabel)
        configureAvatarImage()
        configureUsernameLabel()
        configureNameLabel()
        configureLocationLabel()
        configureBioLabel()
    }

    private func configureAvatarImage() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
    }

    private func configureUsernameLabel() {
        usernameLabel.text = user?.login
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    private func configureNameLabel() {
        nameLabel.text = user?.name
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureLocationLabel() {
        locationLabel.label?.text = user?.location
        if user?.location != nil {
            addSubview(locationLabel)
            NSLayoutConstraint.activate([
                locationLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
                locationLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
                locationLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                locationLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
    }

    private func configureBioLabel() {
        bioLabel.text = user?.bio
        bioLabel.numberOfLines = 3

        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
    }
}
