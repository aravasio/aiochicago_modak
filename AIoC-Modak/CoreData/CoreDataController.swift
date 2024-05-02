import Foundation
import CoreData

class CoreDataController {
    static let shared = CoreDataController()
    
    var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "FavoriteArtwork"
        entity.managedObjectClassName = NSStringFromClass(FavoriteArtwork.self)
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = false
        
        let imageIdAttribute = NSAttributeDescription()
        imageIdAttribute.name = "imageId"
        imageIdAttribute.attributeType = .stringAttributeType
        imageIdAttribute.isOptional = true
        
        let artistDisplayAttribute = NSAttributeDescription()
        artistDisplayAttribute.name = "artistDisplay"
        artistDisplayAttribute.attributeType = .stringAttributeType
        artistDisplayAttribute.isOptional = false
        
        let placeOfOriginAttribute = NSAttributeDescription()
        placeOfOriginAttribute.name = "placeOfOrigin"
        placeOfOriginAttribute.attributeType = .stringAttributeType
        placeOfOriginAttribute.isOptional = true
        
        let dateDisplayAttribute = NSAttributeDescription()
        dateDisplayAttribute.name = "dateDisplay"
        dateDisplayAttribute.attributeType = .stringAttributeType
        dateDisplayAttribute.isOptional = false
        
        let dimensionsAttribute = NSAttributeDescription()
        dimensionsAttribute.name = "dimensions"
        dimensionsAttribute.attributeType = .stringAttributeType
        dimensionsAttribute.isOptional = true
        
        let mediumDisplayAttribute = NSAttributeDescription()
        mediumDisplayAttribute.name = "mediumDisplay"
        mediumDisplayAttribute.attributeType = .stringAttributeType
        mediumDisplayAttribute.isOptional = false
        
        let isPublicDomainAttribute = NSAttributeDescription()
        isPublicDomainAttribute.name = "isPublicDomain"
        isPublicDomainAttribute.attributeType = .booleanAttributeType
        isPublicDomainAttribute.isOptional = false
        
        let isOnViewAttribute = NSAttributeDescription()
        isOnViewAttribute.name = "isOnView"
        isOnViewAttribute.attributeType = .booleanAttributeType
        isOnViewAttribute.isOptional = false
        
        let artworkTypeTitleAttribute = NSAttributeDescription()
        artworkTypeTitleAttribute.name = "artworkTypeTitle"
        artworkTypeTitleAttribute.attributeType = .stringAttributeType
        artworkTypeTitleAttribute.isOptional = false
        
        let termTitlesAttribute = NSAttributeDescription()
        termTitlesAttribute.name = "termTitles"
        termTitlesAttribute.attributeType = .transformableAttributeType
        termTitlesAttribute.isOptional = true
        termTitlesAttribute.valueTransformerName = NSStringFromClass(NSSecureUnarchiveFromDataTransformer.self)
        
        entity.properties = [
            idAttribute,
            titleAttribute,
            imageIdAttribute,
            artistDisplayAttribute,
            placeOfOriginAttribute,
            dateDisplayAttribute,
            dimensionsAttribute,
            mediumDisplayAttribute,
            isPublicDomainAttribute,
            isOnViewAttribute,
            artworkTypeTitleAttribute,
            termTitlesAttribute
        ]
        
        model.entities = [entity]
        
        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
