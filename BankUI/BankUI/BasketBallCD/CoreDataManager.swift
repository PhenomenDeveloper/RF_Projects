//
//  CoreDataManager.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {

    static let sharedInstance = CoreDataManager()
    private init() {}

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "BasketBallCD")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }

    lazy var context: NSManagedObjectContext = {
        let context  = persistentContainer.newBackgroundContext()
        return context
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.newBackgroundContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func getTeams() -> [TeamCD]? {

        let dataTeam = BasketballData()
        dataTeam.teamData()
        var results: [TeamCD]? = []

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamCD")
        do {
            results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [TeamCD]

        } catch {
            print(error)
        }
        return results
    }

    func getPlayers() -> [PlayerCD]? {

        let dataPlayer = BasketballData()
        dataPlayer.playerData()

        var results: [PlayerCD]? = []

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCD")
        do {
            results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [PlayerCD]
        } catch {
            print(error)
        }
        return results
    }

    func getGames(startDate: Date, endDate: Date) -> [CalendarCD] {

        let dataCalendar = BasketballData()
        let result = dataCalendar.getCalendarGames(startDate: startDate, endDate: endDate)

        return result

    }

    func getGames() -> [CalendarCD]? {

        var results: [CalendarCD]? = []

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalendarCD")
        do {
            results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [CalendarCD]
        } catch {
            print(error)
        }

        return results
    }

}
