//
//  CoreDataManager.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 1/31/21.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentData: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Advanced___Coredata___Practice")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}
