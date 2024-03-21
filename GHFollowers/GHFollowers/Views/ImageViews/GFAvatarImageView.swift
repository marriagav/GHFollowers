//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 11/03/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeHolderImage = Images.avatarPlaceholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(from urlString: String) async {
        do {
            let image = try await NetworkManager.shared.getImage(from: urlString)
            setImage(image)
        } catch {
            print(error)
        }
    }

    @MainActor
    private func setImage(_ image: UIImage) {
        self.image = image
    }
}
