//
//  Extension+Date.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 18/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let historyDateFormatFromJson: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'+03:00'"
        return formatter
    }()

    static let historyDataFormatWithLogoFromJson: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()

    static let transactionsDataFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
