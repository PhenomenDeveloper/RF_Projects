//
//  NetworkHintModel.swift
//  AwesomeDebouncer
//
//  Created by Lev Kolesnikov on 29.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

struct NetworkHintModel: Codable {
    var suggestions: [Hint]
    
    struct Hint: Codable {
        var value: String
    }
}
