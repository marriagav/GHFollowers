//
//  GFIconLabel.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class GFIconLabel: UIView {
//    var label = GFBodyLabel(frame: .zero)
    var label: UILabel?
    var icon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(label: UILabel, textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        label.textAlignment = textAlignment
        self.label = label
        configure()
    }

    private func configure() {
        guard let label = label else { return }
        icon.tintColor = .secondaryLabel
        addSubview(icon)
        addSubview(label)
        icon.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),

            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
