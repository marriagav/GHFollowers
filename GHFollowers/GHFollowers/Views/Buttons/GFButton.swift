//
//  GFButton.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 08/03/24.
//

import UIKit

class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(color: UIColor, title: String, systemImage: SFSymbols) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImage: systemImage)
    }

    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(color: UIColor, title: String, systemImage: SFSymbols) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title

        configuration?.image = systemImage.symbolImage
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

#Preview {
    let button = GFButton(color: .blue, title: "Test Button", systemImage: .followers)
    return button
}
