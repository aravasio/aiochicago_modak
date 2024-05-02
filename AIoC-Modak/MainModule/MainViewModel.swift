import SwiftUI

enum MainViewModelState {
    case loading
    case loaded(data: [Artwork])
    case error(Error)
}

@MainActor
class MainViewModel: ObservableObject {
    @Published var state: MainViewModelState
    private let networkClient: NetworkClientProtocol
    private var artworks: [Artwork] = []
    private var currentPage = 0
    private var totalPages = 1
    @Published var isLoading = false
    
    init(initialState: MainViewModelState, networkClient: NetworkClientProtocol) {
        self.state = initialState
        self.networkClient = networkClient
    }
    
    func next() async {
        guard !isLoading, currentPage < totalPages else {
            return
        }
        await fetchData(for: currentPage + 1)
    }
    
    @MainActor
    func fetchData(for page: Int = 0) async {
        isLoading = true
        do {
            let response = try await networkClient.fetchResource(page: page, expecting: ArtworkResponse.self)
            totalPages = response.pagination.totalPages
            currentPage = response.pagination.currentPage
            isLoading = false
            artworks = artworks + response.data
            state = .loaded(data: artworks)
        } catch {
            state = .error(error)
            isLoading = false
        }
    }
}
