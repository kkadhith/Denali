//
//  PersistenceController.swift
//  DenaliTestingEnv
//
//  Created by Adhith Karthikeyan on 4/6/25.
//  Licensed under Apache License v2.0
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "HikeDataModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failure: \(error.localizedDescription)")
            }
        }
    }
}
