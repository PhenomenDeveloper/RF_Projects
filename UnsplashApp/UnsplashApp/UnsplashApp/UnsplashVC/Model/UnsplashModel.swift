//
//  UnsplashModel.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let color: String
    let urls: [URLKind.RawValue: String]
}
