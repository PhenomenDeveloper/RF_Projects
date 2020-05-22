//
//  Player.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

class Player: Decodable {
  let playerID: String
  let teamID: String
  let name: String
  let surName: String
  let number: Int
  let hieght: Int
  let weight: Int
  let dateBirth: String
  let position: String
  let titul: String?

  func getImageNamed() -> String {
    return "default"
  }
}
