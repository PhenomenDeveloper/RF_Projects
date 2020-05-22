//
//  PlayersDataProvider.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

protocol PlayersDataProvider {
  func getPlayers() -> [Player]
}

class  PlayersDataProviderImp: PlayersDataProvider {
  static let shared = PlayersDataProviderImp()

  private var players =  [Player]()

  init() {
    players = self.loadModels()
  }

  private func loadModels() -> [Player] {
    if let path = Bundle.main.path(forResource: "players", ofType: "json") {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

          let decoder = JSONDecoder()
          let models = try decoder.decode([Player].self, from: data)

          return models
          } catch let error {
               // handle error
            print("parsing error \(error)")
          }
    }

    return [Player]()
  }

  func getPlayers() -> [Player] {
      return players
  }
}
