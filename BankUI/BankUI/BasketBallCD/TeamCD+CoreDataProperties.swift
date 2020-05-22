//
//  TeamCD+CoreDataProperties.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//
//

import Foundation
import CoreData

extension TeamCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamCD> {
        return NSFetchRequest<TeamCD>(entityName: "TeamCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var pictures: String?
    @NSManaged public var players: NSArray
    @NSManaged public var teamId: String?
    @NSManaged public var guestCalendar: NSSet?
    @NSManaged public var homeCalendar: NSSet?
    @NSManaged public var team_players: NSSet?

}

// MARK: Generated accessors for guestCalendar
extension TeamCD {

    @objc(addGuestCalendarObject:)
    @NSManaged public func addToGuestCalendar(_ value: CalendarCD)

    @objc(removeGuestCalendarObject:)
    @NSManaged public func removeFromGuestCalendar(_ value: CalendarCD)

    @objc(addGuestCalendar:)
    @NSManaged public func addToGuestCalendar(_ values: NSSet)

    @objc(removeGuestCalendar:)
    @NSManaged public func removeFromGuestCalendar(_ values: NSSet)

}

// MARK: Generated accessors for homeCalendar
extension TeamCD {

    @objc(addHomeCalendarObject:)
    @NSManaged public func addToHomeCalendar(_ value: CalendarCD)

    @objc(removeHomeCalendarObject:)
    @NSManaged public func removeFromHomeCalendar(_ value: CalendarCD)

    @objc(addHomeCalendar:)
    @NSManaged public func addToHomeCalendar(_ values: NSSet)

    @objc(removeHomeCalendar:)
    @NSManaged public func removeFromHomeCalendar(_ values: NSSet)

}

// MARK: Generated accessors for team_players
extension TeamCD {

    @objc(addTeam_playersObject:)
    @NSManaged public func addToTeam_players(_ value: PlayerCD)

    @objc(removeTeam_playersObject:)
    @NSManaged public func removeFromTeam_players(_ value: PlayerCD)

    @objc(addTeam_players:)
    @NSManaged public func addToTeam_players(_ values: NSSet)

    @objc(removeTeam_players:)
    @NSManaged public func removeFromTeam_players(_ values: NSSet)

}
