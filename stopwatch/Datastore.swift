//
//  Datastore.swift
//  stopwatch
//
//  Created by Alex Eroshin on 8/8/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import Foundation
import CoreData

class Timer: NSManagedObject {
	@NSManaged var date: NSDate
	@NSManaged var duration: Double
	
	static let entityName: String = "Timer"
}

class Datastore {
	
	static let instance = Datastore()
	
	// <CoreData>
	
	private lazy var applicationDocumentsDirectory: NSURL = {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls.last!
	}()
	
	private lazy var managedObjectModel: NSManagedObjectModel = {
		let modelURL = NSBundle.mainBundle().URLForResource("Timer", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
	}()
	
	private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Timer.sqlite")
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
		} catch {
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
			dict[NSLocalizedFailureReasonErrorKey] = failureReason
			
			dict[NSUnderlyingErrorKey] = error as NSError
			let wrappedError = NSError(domain: "ERROR", code: 999, userInfo: dict)
			
			NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
			abort()
		}
		
		return coordinator
	}()
	
	private lazy var managedObjectContext: NSManagedObjectContext = {
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	private func saveContext () {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
	// <CoreData/>
	
	// <Public methods to use>
	
	func fetchTimers() -> [Timer] {
		let fetchRequest = NSFetchRequest(entityName: "Timer")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		do {
			let results = try managedObjectContext.executeFetchRequest(fetchRequest)
			return results as! [Timer]
		} catch let error as NSError {
			NSLog("Data fetching error: \(error)")
			return []
		}
	}
	
	func saveTimer(date: NSDate, duration: Double) {
        if duration == 0{
            return
        }

		let timer = NSEntityDescription.insertNewObjectForEntityForName(Timer.entityName, inManagedObjectContext: managedObjectContext) as! Timer
		timer.date = date
		timer.duration = duration
		
		saveContext()
	}
	
	// <Public methods to use/>
	
}