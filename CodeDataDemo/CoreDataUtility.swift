//
//  CoreDataUtility.swift
//  CodeDataDemo
//
//  Created by Amol Bombe on 26/02/17.
//  Copyright © 2017 Amol Bombe. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataUtility {
    
    class func fetchData(entityName: String)-> [NSManagedObject]? {
        
        // Fetch Data
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            return data
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func insertData(values: [String: Any?], entityName: String) {
        
        // Insert Data
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            return
        }
        
        let entityData = NSManagedObject(entity: entity, insertInto: managedContext)
        for value in values {
        entityData.setValue(value.value, forKey: value.key)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    class func deleteData(data: NSManagedObject) -> Bool {
        
        // Delete Data
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(data)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save \(error)")
            return true
        }

    }
}
