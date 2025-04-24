//
//  CoreData.swift
//  PokemonProject
//
//  Created by 형윤 on 4/24/25.
//
import CoreData
import UIKit

class CoreData {
    static let shared = CoreData()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "ContactModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData Load Error: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
