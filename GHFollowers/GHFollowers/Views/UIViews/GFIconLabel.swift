//
//  GFIconLabel.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class GFIconLabel: UIView {
    var label: UILabel?
    var iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(label: UILabel, systemIcon: String, textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        label.textAlignment = textAlignment
        iconView.image = UIImage(systemName: systemIcon)
        self.label = label
        configure()
    }

    private func configure() {
        guard let label = label else { return }
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFill
        addSubview(iconView)
        addSubview(label)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
