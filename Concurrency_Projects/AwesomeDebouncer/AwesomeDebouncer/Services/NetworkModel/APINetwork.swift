//
//  APINetwork.swift
//  AwesomeDebouncer
//
//  Created by Lev Kolesnikov on 29.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

struct APINetwork {
    static let scheme = "https"
    static let host = "suggestions.dadata.ru"
    static let token = "693f5a1119bce1513470b1002e9ad02664e30208"
    
    static let country = "/suggestions/api/4_1/rs/suggest/country"
    static let bank = "/suggestions/api/4_1/rs/suggest/bank"
    static let address = "/suggestions/api/4_1/rs/suggest/address"
}
