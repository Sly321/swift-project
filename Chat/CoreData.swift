
import UIKit
import CoreData

class CoreData: NSObject {
    
    let mOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    // Beschreibt Entity in Core Data
    func insert(entityName: String, id: AnyObject?, data: Dictionary<String, AnyObject>) {
        
        // unique leer ODER nicht in Core Data
        if (id == nil ||
            id != nil && get(entityName, format: "id", predicat: id?.description) == nil) {
            
            let eD = NSEntityDescription.entityForName(entityName, inManagedObjectContext: mOC!)
            let mO = NSManagedObject(entity: eD!, insertIntoManagedObjectContext:mOC)
           
            for key in eD!.propertiesByName.keys {
                if  data.indexForKey(key.description) != nil {
                    mO.setValue(data[key.description], forKey: key.description)
                }
            }
        
            mOC!.save(nil)
        }
    }

    func getManagedObject(entityName: String, format: String, predicat: String) -> NSManagedObject {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "(\(format) = %@)", predicat)
        let requestResult = mOC?.executeFetchRequest(request, error: nil)
        
        var user: NSManagedObject
        
        if requestResult!.count > 0 {
            for result in requestResult!.generate() {
                return result as! NSManagedObject
        
            }
        }
        
        return NSManagedObject()
    }
    
    func get(entityName: String, predicat: String?) -> Array<Dictionary<String,  AnyObject>> {
        var dic = Dictionary<String, AnyObject>()
        var arr = Array<Dictionary<String, AnyObject>>()
        let request = NSFetchRequest(entityName: entityName)
        
        if (entityName == "Message") {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            let sortDescriptors = [sortDescriptor]
            request.sortDescriptors = sortDescriptors
        }
        
        if (predicat != nil) {
            request.predicate = NSPredicate(format: "(id = %@)", predicat!)
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)
        
        if (result!.count > 0) {
            
            for item in result!.generate() {
                
                for key in item.entity.propertiesByName.keys {
                    dic[key.description] = item.valueForKey(key.description)
                }
                
                arr.append(dic)
            }
            
            
        }
        
        return arr
        
    }
    
    func getById(entityName: String, predicat: String) -> Dictionary<String, AnyObject>? {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "(id = %@)", predicat)
        let result = mOC?.executeFetchRequest(request, error: nil)

        if (result!.count == 1) {
            var data = Dictionary<String, AnyObject>()
            for key in result!.first!.entity.propertiesByName.keys {
                data[key.description] = result!.first!.valueForKey(key.description)
            }
            
            return data
        }
        
        return nil
    }
    
    func getAll(entityName: String, properties: [AnyObject]?) -> [AnyObject]? {
        let request = NSFetchRequest(entityName: entityName)
        
        if (properties != nil) {
            request.propertiesToFetch = properties
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)

        if (result?.count > 0) {
            return result
            
        } else {
            return nil
        }
        
        
    }
    
    // Holt Inhalt aus Entity
    func get(entityName: String, format: String?, predicat: String?) -> (Array<Dictionary<String, AnyObject>>, Dictionary<String, AnyObject>)? {
        
        let request = NSFetchRequest(entityName: entityName)
        
        if (format != nil && predicat != nil) {
            request.predicate = NSPredicate(format: "(\(format!) = %@)", predicat!)
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)
        
        if (result!.count > 0) {
            var data = Dictionary<String, AnyObject>()
            var multiData = Array<Dictionary<String, AnyObject>>()
            
            for item in result!.generate() {
                
                for key in item.entity.propertiesByName.keys {
                    data[key.description] = item.valueForKey(key.description)
                }
                
                multiData.append(data)
            }
            
            return (multiData, data)
        }
        
        return nil
    }
}