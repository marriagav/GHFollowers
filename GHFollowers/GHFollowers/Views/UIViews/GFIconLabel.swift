//
//  GFIconLabel.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class GFIconLabel: UIView {
    var label = GFBodyLabel(frame: .zero)
    var icon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        label.textAlignment = textAlignment
        configure()
    }

    private func configure() {
        icon.tintColor = .secondaryLabel
        addSubview(icon)
        addSubview(label)
        icon.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10)
        ])
    }
}
