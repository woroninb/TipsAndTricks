import Foundation
import CoreData

enum RMTCoreDataError: ErrorType {
    case IncompleteDataForEntity
}

final class CoreDataStack {
    
    static let sharedStack = CoreDataStack()
    
    //Since we’re using two contexts, we need to merge changes between them. Changes inside the Core Data stack will not automatically propagate from the persistent store coordinator up to the managed object context. By merging changes between the two contexts, both contexts will update themselves from the persistent store coordinator as changes are merged into them
    
    
    private init() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mainContextChanged:", name: NSManagedObjectContextDidSaveNotification, object: self.managedObjectContext)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "bgContextChanged:", name: NSManagedObjectContextDidSaveNotification, object: self.backgroundManagedObjectContext)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        
        let coordinator = self.persistentStoreCoordinator
        
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        
        return privateManagedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let coordinator = self.persistentStoreCoordinator
        
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        mainManagedObjectContext.persistentStoreCoordinator = coordinator
        
        return mainManagedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
        if backgroundManagedObjectContext.hasChanges {
            do {
                try backgroundManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    @objc func mainContextChanged(notification: NSNotification) {
        backgroundManagedObjectContext.performBlock { [unowned self] in
            self.backgroundManagedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
    
    @objc func bgContextChanged(notification: NSNotification) {
        managedObjectContext.performBlock { [unowned self] in
            self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        }
        
    }
}
