//
//  NetworkAuthModel.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 17/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

protocol NetworkAuthModelProtocol {
    var accessToken: String { get }
    var resourceOwner: ResourceOwnerModel { get }
}

struct NetworkAuthModel: Codable, NetworkAuthModelProtocol {
    var accessToken: String
    var resourceOwner: ResourceOwnerModel
}

struct ResourceOwnerModel: Codable {
    var firstName: String
    var lastName: String
    var mobilePhone: String
    var email: String
}

struct NetworkUser {
    static var userToken: String = ""
    var name: String
    var mobilePhone: String
    var email: String
}
