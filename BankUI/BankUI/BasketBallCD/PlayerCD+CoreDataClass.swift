//
//  PlayerCD+CoreDataClass.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlayerCD)
public class PlayerCD: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.sharedInstance.entityForName(entityName: "PlayerCD"), insertInto: CoreDataManager.sharedInstance.context)
    }
}
