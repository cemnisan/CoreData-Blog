//
//  CoreDataStack.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import CoreData

final class CoreDataStack
{
    private let modelName: String
    
    init(modelName: String)
    {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error: \(error), \(error)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
}

extension CoreDataStack
{
    func saveContext()
    {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
}
