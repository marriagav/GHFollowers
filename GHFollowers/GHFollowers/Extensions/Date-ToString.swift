//
//  Date-ToString.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 19/03/24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
