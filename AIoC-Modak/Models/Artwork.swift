import Foundation
import UIKit

struct Artwork: Codable, Identifiable {
    let id: Int
    let title: String
    let imageId: String?
    let artistDisplay: String
    let placeOfOrigin: String?
    let dateDisplay: String
    let dimensions: String?
    let mediumDisplay: String
    let isPublicDomain: Bool
    let isOnView: Bool
    let artworkTypeTitle: String
    let termTitles: [String]
    
    var iiifImageUrl: URL? {
        guard let imageId else { return nil }
        let baseUrl = "https://www.artic.edu/iiif/2"
        let size = "843,"  // Recommended size, adjust as needed
        let path = "\(imageId)/full/\(size)/0/default.jpg"
        return URL(string: "\(baseUrl)/\(path)")
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, title, dimensions
        case artistDisplay = "artist_display"
        case placeOfOrigin = "place_of_origin"
        case dateDisplay = "date_display"
        case mediumDisplay = "medium_display"
        case isPublicDomain = "is_public_domain"
        case isOnView = "is_on_view"
        case imageId = "image_id"
        case artworkTypeTitle = "artwork_type_title"
        case termTitles = "term_titles"
    }
}
