import CoreData

class FavoriteArtwork: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var title: String
    @NSManaged var imageId: String?
    @NSManaged var artistDisplay: String
    @NSManaged var placeOfOrigin: String?
    @NSManaged var dateDisplay: String
    @NSManaged var dimensions: String?
    @NSManaged var mediumDisplay: String
    @NSManaged var isPublicDomain: Bool
    @NSManaged var isOnView: Bool
    @NSManaged var artworkTypeTitle: String
    @NSManaged var termTitles: [String]
}
