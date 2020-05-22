//
//  TeamDataProvider.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

protocol TeamDataProvider {
  func getTeams() -> [Team]
}

class TeamDataProviderImp: TeamDataProvider {

  static let shared = TeamDataProviderImp()
  private var teams = [Team]()

  private init() {
    teams = loadModels()
  }

  private func loadModels() -> [Team] {
    if let path = Bundle.main.path(forResource: "Teams", ofType: "json") {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

          let decoder = JSONDecoder()
          let teams = try decoder.decode([Team].self, from: data)
          return teams
          } catch let error {
               // handle error
            print("parsing error \(error)")
          }
    }

    return [Team]()
  }

  func getTeams() -> [Team] {
    return teams
  }
}
