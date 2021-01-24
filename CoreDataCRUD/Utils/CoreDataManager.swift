//
//  CoreDataManager.swift
//  CoreDataCRUD
//
//  Created by Thomas Woodfin on 1/8/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let sharedManager = CoreDataManager()
    private init() {}
    
    var userList = [UserResponse]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.dbName)
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(name: String, completion: @escaping (_ success: Bool) -> Void){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.dbTableName, in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(name, forKeyPath: "username")
        user.setValue("\(name)@test.com", forKeyPath: "email")
        user.setValue(name, forKey: "password")
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }

    func retrieveData(completion: @escaping (_ success: Bool) -> Void) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dbTableName)
        
        do {
            userList.removeAll()
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let email = data.value(forKey: "email") as? String
                let name = data.value(forKey: "username") as? String
                let data = UserResponse(name: name, email: email)
                userList.append(data)
            }
            completion(true)
        } catch {
            print("Failed")
            completion(false)
        }
    }
    
    func updateData(oldName: String, newName: String, completion: @escaping (_ success: Bool) -> Void){
    
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.dbTableName)
        fetchRequest.predicate = NSPredicate(format: "username = %@", oldName)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
   
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(newName, forKey: "username")
                objectUpdate.setValue("\(newName)@test.com", forKey: "email")
                objectUpdate.setValue(newName, forKey: "password")
                do{
                    try managedContext.save()
                    completion(true)
                }
                catch
                {
                    print(error)
                    completion(false)
                }
            }
        catch
        {
            print(error)
            completion(false)
        }
   
    }
    
    func deleteData(name: String, completion: @escaping (_ success: Bool) -> Void){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dbTableName)
        fetchRequest.predicate = NSPredicate(format: "username = %@", name)
       
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                completion(true)
            }
            catch
            {
                print(error)
                completion(false)
            }
            
        }
        catch
        {
            print(error)
            completion(false)
        }
    }
}
