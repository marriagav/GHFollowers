//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 11/03/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeHolderImage = UIImage(named: "avatar-placeholder")
    let cache = NetworkManager.shared.imageCache

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
        let imageKey = NSString(string: urlString)
        if let image = cache.object(forKey: imageKey) {
            setImage(image)
            return
        }

        do {
            guard let url = URL(string: urlString) else { throw GFError.invalidURL }
            let data = try await NetworkManager.shared.getRequest(url: url)
            guard let image = UIImage(data: data) else {
                throw GFError.invalidData
            }
            cache.setObject(image, forKey: imageKey)
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
