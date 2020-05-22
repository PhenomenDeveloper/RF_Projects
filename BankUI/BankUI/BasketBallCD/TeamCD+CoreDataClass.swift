//
//  TeamCD+CoreDataClass.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TeamCD)
public class TeamCD: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.sharedInstance.entityForName(entityName: "TeamCD"), insertInto: CoreDataManager.sharedInstance.context)
    }
}
