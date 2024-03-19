//
//  GFIconLabelCountView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 15/03/24.
//

import UIKit

enum ItemInfoType {
    case repos
    case gists
    case followers
    case following
}

class GFIconLabelCountView: UIView {
    var countLabel: UILabel?
    var iconLabel: GFIconLabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
        iconLabel = GFIconLabel(frame: .zero)
        countLabel?.translatesAutoresizingMaskIntoConstraints = false
        iconLabel?.translatesAutoresizingMaskIntoConstraints = false
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(iconLabel: GFIconLabel, countLabel: UILabel) {
        super.init(frame: .zero)
        self.iconLabel = iconLabel
        self.countLabel = countLabel
        configure()
    }

    init(itemInfoType: ItemInfoType, withCount count: Int) {
        super.init(frame: .zero)
        countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
        set(itemInfoType: itemInfoType, withCount: count)
        configure()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let iconLabel = iconLabel, let countLabel = countLabel else {
            return
        }
        addSubview(iconLabel)
        addSubview(countLabel)
        iconLabel.iconView.tintColor = .label
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: topAnchor),
            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            countLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countLabel.centerXAnchor.constraint(equalTo: iconLabel.centerXAnchor)
        ])
    }

    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            iconLabel?.set(
                systemIcon: SFSymbols.repos,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Public Repos"
        case .gists:
            iconLabel?.set(
                systemIcon: SFSymbols.gists,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Public Gists"
        case .followers:
            iconLabel?.set(
                systemIcon: SFSymbols.followers,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Followers"
        case .following:
            iconLabel?.set(
                systemIcon: SFSymbols.following,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Following"
        }
        countLabel?.text = count.description
    }
}

#Preview {
    let preview = GFIconLabelCountView()
    preview.set(itemInfoType: .following, withCount: 11)
    return preview
}
