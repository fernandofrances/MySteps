//
//  CoreDataManager.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import CoreData

enum CoreDataEntities: String {
    case user = "UserEntity"
}

class CoreDataManager {
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    
    func createUserData(_ user: User) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataEntities.user.rawValue, in: context) else { return }
        
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        newUser.setValue(user.totalSteps, forKey: "totalSteps")
        newUser.setValue(user.name, forKey: "name")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    func updateUserSteps(_ steps: Double) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.user.rawValue)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            let update = result.first as! NSManagedObject
            update.setValue(steps, forKey: "totalSteps")
            
            do {
                try context.save()
            } catch {
                print(error)
            }
            
        } catch {
            print("Failed updating data")
        }
        
    }
    
    func getUserSteps() -> Double {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.user.rawValue)
        let context = appDelegate.persistentContainer.viewContext
        
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                return data.value(forKey: "totalSteps") as! Double
            }
        } catch {
            print("Failed getting data")
        }
        return 0
    }
}
