//
//  CalendarDataProvider.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

protocol CaledarDataProvider {
  func getGames(startDate: Date, endDate: Date) -> [Game]
}

class CalendarDataProviderImp: CaledarDataProvider {

  static let shared = CalendarDataProviderImp()

  private var models = [Game]()

  private init() {
    models = self.loadModels()

  }

  private func loadModels() -> [Game] {
    if let path = Bundle.main.path(forResource: "calender", ofType: "json") {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

          let decoder = JSONDecoder()
          let matchesDTO = try decoder.decode([MatchDTO].self, from: data)
          return matchesDTO.map { Game(dto: $0) }
          } catch let error {
               // handle error
            print("parsing error \(error)")
          }
    }

    return [Game]()
  }

  func getGames(startDate: Date, endDate: Date) -> [Game] {
    return self.models.filter {
        return $0.startDate >= startDate &&  ($0.endDate == nil || $0.endDate! <= endDate)
    }
   }
}
