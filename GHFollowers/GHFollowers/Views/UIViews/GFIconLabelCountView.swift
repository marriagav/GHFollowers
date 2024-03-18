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
            iconLabel.heightAnchor.constraint(equalToConstant: 20),

            countLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 12),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countLabel.centerXAnchor.constraint(equalTo: iconLabel.centerXAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
        switch itemInfoType {
        case .repos:
            iconLabel = .init(
                label: GFTitleLabel(textAlignment: .left, fontSize: 14),
                systemIcon: SFSymbols.repos,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Public Repos"
        case .gists:
            iconLabel = .init(
                label: GFTitleLabel(textAlignment: .left, fontSize: 14),
                systemIcon: SFSymbols.gists,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Gists"
        case .followers:
            iconLabel = .init(
                label: GFTitleLabel(textAlignment: .left, fontSize: 14),
                systemIcon: SFSymbols.followers,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Followers"
        case .following:
            iconLabel = .init(
                label: GFTitleLabel(textAlignment: .left, fontSize: 14),
                systemIcon: SFSymbols.following,
                textAlignment: .left
            )
            iconLabel?.label?.text = "Public Repos"
        }
        countLabel?.text = count.description
    }
}

#Preview {
    let preview = GFIconLabelCountView(itemInfoType: .following, withCount: 11)
    return preview
}
