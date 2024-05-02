import Foundation

protocol Mappable: Codable {
    static func endpoint(for: Int) -> String
}

struct ArtworkResponse: Mappable {
    static func endpoint(for page: Int) -> String {
        let fields = Artwork.CodingKeys.allCases.map { $0.rawValue }.joined(separator: ",")
        let url = "https://api.artic.edu/api/v1/artworks?page=\(page)&fields=\(fields)"
        print("fetching from: \(url)")
        return url
    }
    
    let pagination: Pagination
    let data: [Artwork]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case pagination, data
    }
}

struct Pagination: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
    let nextUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case total, limit, offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextUrl = "next_url"
    }
}
