//
//  UIView-Subview.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 21/03/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
