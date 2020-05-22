//
//  CalendarCD+CoreDataProperties.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//
//

import Foundation
import CoreData

extension CalendarCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarCD> {
        return NSFetchRequest<CalendarCD>(entityName: "CalendarCD")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var guestScore: Int32
    @NSManaged public var guestTeam: String?
    @NSManaged public var homeScore: Int32
    @NSManaged public var homeTeam: String?
    @NSManaged public var startdDate: Date?
    @NSManaged public var guest_team: TeamCD?
    @NSManaged public var home_team: TeamCD?

}
