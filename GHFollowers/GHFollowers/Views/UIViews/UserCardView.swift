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
    var usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 35)
    var nameLabel = GFBodyLabel(textAlignment: .left)
    var locationLabel = GFIconLabel(textAlignment: .left)
    var bioLabel = GFBodyLabel(textAlignment: .left)

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
        configureAvatarImage()
        configureUsernameLabel()
        configureLocationLabel()
        configureNameLabel()
        configureBioLabel()
    }

    private func configureAvatarImage() {
        addSubview(avatarImageView)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
    }

    private func configureUsernameLabel() {
        usernameLabel.text = user?.login
        addSubview(usernameLabel)

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configureNameLabel() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        nameLabel.text = user?.name
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        container.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            container.bottomAnchor.constraint(equalTo: locationLabel.topAnchor),
            container.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureLocationLabel() {
        locationLabel.label.text = user?.location
        locationLabel.label.font = .preferredFont(forTextStyle: .headline)
        if user?.location != nil {
            locationLabel.icon.image = UIImage(systemName: "mappin.and.ellipse")
        }
        addSubview(locationLabel)

        NSLayoutConstraint.activate([
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
        ])
    }

    private func configureBioLabel() {
        bioLabel.text = user?.bio

        addSubview(bioLabel)
        bioLabel.numberOfLines = 3

        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
    }
}
