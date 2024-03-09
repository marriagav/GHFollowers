//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 08/03/24.
//

import UIKit

class GFTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        keyboardType = .default
        returnKeyType = .go
        placeholder = "Enter a user name"
    }
}

#Preview {
    let textField = GFTextField(frame: .zero)
    return textField
}
