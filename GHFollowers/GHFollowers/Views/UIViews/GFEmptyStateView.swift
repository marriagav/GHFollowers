//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 12/03/24.
//

import UIKit

class GFEmptyStateView: UIView {
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }

    private func configure() {
        addSubviews(messageLabel, logoImageView)
        configureMessageLabel()
        configureLogoImageView()
    }

    private func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        let messageLabelCenterYConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes
            .isiPhone8Zoomed || DeviceTypes.isiPhoneSE2 ? -90 : -150

        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(
            equalTo: centerYAnchor,
            constant: messageLabelCenterYConstraintConstant
        )

        NSLayoutConstraint.activate([
            messageLabelCenterYConstraint,
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureLogoImageView() {
        logoImageView.image = Images.emptyState
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let logoImageViewBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes
            .isiPhone8Zoomed || DeviceTypes.isiPhoneSE2 ? 100 : 40

        let logoImageViewBottomAnchorConstraint = logoImageView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: logoImageViewBottomConstant
        )

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageViewBottomAnchorConstraint
        ])
    }
}
