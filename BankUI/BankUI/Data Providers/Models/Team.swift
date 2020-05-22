//
//  Team.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

class Team: Decodable {
  let teamId: String
  let picture: String
  let name: String
  let players: [String]
}
