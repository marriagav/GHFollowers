//
//  Date-ToString.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 19/03/24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
