//
//  NetworkHistoryModel.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 17/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

struct NetworkContent: Codable {
    var content: [NetworkHistoryData]
    var totalPages: Int

    struct NetworkHistoryData: Codable, Equatable {
        var id: Int
        var sendAt: Date
        var title: String
        var body: String
        var params: Params

        struct Params: Codable {
            var transactionDate: String
        }

        static func == (lhs: NetworkHistoryData, rhs: NetworkHistoryData) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

struct NetwrokHistoryModel {
    var sendAt: Date
    var title: String
    var body: String
    var transactionDate: String
}
