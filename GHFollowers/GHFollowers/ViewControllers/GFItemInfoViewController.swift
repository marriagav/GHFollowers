//
//  GFItemInfoViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 17/03/24.
//

import UIKit

class GFItemInfoViewController: UIViewController {
    let stackView = UIStackView()
    let itemInfoViewOne = GFIconLabelCountView()
    let itemInfoViewTwo = GFIconLabelCountView()
    let actionButton = GFButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
    }

    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
