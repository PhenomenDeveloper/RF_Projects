//
//  Match.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

class Game {
  let homeTeam: String
  let guestTeam: String
  let startDate: Date
  let homeScore: Int
  let guestScore: Int
  let endDate: Date?

  init(dto: MatchDTO) {
    homeTeam = dto.homeTeam
    guestTeam = dto.guestTeam
    let formatter = FullDateFormatter()
    formatter.timeZone = .current

    startDate = formatter.date(from: dto.startdDate)!
    let endDate = formatter.date(from: dto.endDate)!
    if startDate <= Date() && endDate <= Date() {
      self.endDate = endDate
      homeScore = dto.homeScore
      guestScore = dto.guestScore
    } else {
      self.endDate = nil
      homeScore = 0
      guestScore = 0
    }
  }
}

class MatchDTO: Decodable {
  let homeTeam: String
  let guestTeam: String
  let startdDate: String
  let homeScore: Int
  let guestScore: Int
  let endDate: String
}
