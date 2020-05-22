//
//  TimeHelpers.swift
//  Raiffeisen.streetball.3x3
//
//  Created by KALASHNIKOV Dmitry on 06/12/2019.
//  Copyright © 2019 KALASHNIKOV Dmitry. All rights reserved.
//

import Foundation

class FullDateFormatter: DateFormatter {
  override init() {
    super.init()
    dateFormat = "yyyy-MM-dd-HH:mm"
    calendar = Calendar(identifier: .gregorian)
    timeZone = .current
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
