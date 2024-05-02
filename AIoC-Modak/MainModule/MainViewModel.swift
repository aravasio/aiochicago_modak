import SwiftUI
import CoreData

enum MainViewModelState {
    case loading
    case loaded(data: [Artwork])
    case error(Error)
}

@MainActor
protocol MainViewModelProtocol: ObservableObject {
    var viewContext: NSManagedObjectContext { get }
}

class MainViewModel: MainViewModelProtocol {
    @Published var state: MainViewModelState
    @Published var showFavoritesOnly = false
    
    var isLoading = false
    var viewContext: NSManagedObjectContext

    private let networkClient: NetworkClientProtocol
    private var artworks: [Artwork] = []
    private var currentPage = 0
    private var totalPages = 1
    
    init(initialState: MainViewModelState, networkClient: NetworkClientProtocol, context: NSManagedObjectContext) {
        self.state = initialState
        self.networkClient = networkClient
        self.viewContext = context
    }
    
    func next() async {
        guard !isLoading, currentPage < totalPages else {
            return
        }
        await fetchData(for: currentPage + 1)
    }
    
    func fetchData(for page: Int = 0) async {
        isLoading = true
        do {
            let response = try await networkClient.fetchResource(page: page, expecting: ArtworkResponse.self)
            totalPages = response.pagination.totalPages
            currentPage = response.pagination.currentPage
            let newArtworks = response.data
            if showFavoritesOnly {
                artworks = (artworks + newArtworks).filter { isArtworkFavorite(id: $0.id) }
            } else {
                artworks = artworks + newArtworks
            }
            state = .loaded(data: artworks)
            isLoading = false
        } catch {
            state = .error(error)
            isLoading = false
        }
    }
    
    func toggleFavorites() {
        showFavoritesOnly.toggle()
        if showFavoritesOnly {
            state = .loaded(data: artworks.filter { isArtworkFavorite(id: $0.id) })
        } else {
            state = .loaded(data: artworks)
        }
    }
    
    private func isArtworkFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteArtwork")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error fetching favorite status: \(error)")
            return false
        }
    }
}
