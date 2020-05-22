//
//  SearchResults.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

enum URLKind: String {
    case full
    case regular
    case thumb
}

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}
