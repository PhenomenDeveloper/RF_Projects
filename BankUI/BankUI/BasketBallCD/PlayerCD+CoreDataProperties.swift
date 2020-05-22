//
//  PlayerCD+CoreDataProperties.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//
//

import Foundation
import CoreData

extension PlayerCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerCD> {
        return NSFetchRequest<PlayerCD>(entityName: "PlayerCD")
    }

    @NSManaged public var dateBirth: String?
    @NSManaged public var hieght: Int32
    @NSManaged public var name: String?
    @NSManaged public var number: Int32
    @NSManaged public var playerID: String?
    @NSManaged public var position: String?
    @NSManaged public var surName: String?
    @NSManaged public var teamID: String?
    @NSManaged public var titul: String?
    @NSManaged public var weight: Int32
    @NSManaged public var players_team: TeamCD?

}
