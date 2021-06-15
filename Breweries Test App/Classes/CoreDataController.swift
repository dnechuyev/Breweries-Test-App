//
//  CoreDataController.swift
//  Breweries Test App
//
//  Created by Dmytro Nechuyev on 09.06.2021.
//

import Foundation
import CoreData

class CoreDataController {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataController()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getTwentyBreweries(fetchOffset: Int = 0) -> [BreweriesEntity] {
        
        let request: NSFetchRequest<BreweriesEntity> = BreweriesEntity.fetchRequest()
        request.fetchLimit = 20
        request.fetchOffset = fetchOffset
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getAllBreweries() -> [BreweriesEntity] {
        
        let request: NSFetchRequest<BreweriesEntity> = BreweriesEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func search(query: String) -> [BreweriesEntity] {
        
        let request: NSFetchRequest<BreweriesEntity> = BreweriesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Breweries_Test_App")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
}
