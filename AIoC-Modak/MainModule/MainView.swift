import SwiftUI
import Combine

struct DetailView: View {
    
    var body: some View {
        Text("Detail view")
    }
}

struct MainView: View {
    @ObservedObject var model: MainViewModel
    
    var body: some View {
        Group {
            switch model.state {
            case .loading:
                showLoadingView()
            case .loaded(let data):
                showDataView(with: data)
            case .error(let error):
                showErrorView(message: error.localizedDescription)
            }
        }
        .onAppear {
            Task {
                await model.fetchData()
            }
        }
    }
    
    @ViewBuilder
    func showLoadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    @ViewBuilder
    func showDataView(with artworks: [Artwork]) -> some View {
        List {
            ForEach(artworks, id: \.id) { artwork in
                NavigationLink(destination: DetailView()) {
                    ArtworkRowView(artwork: artwork)
                        .padding(.horizontal)
                }
                .onAppear {
                    if shouldFetchNext(artwork: artwork, from: artworks) {
                        Task { await model.next() }
                    }
                }
            }
        }
    }
    
    private func shouldFetchNext(artwork: Artwork, from source: [Artwork]) -> Bool {
        guard !model.isLoading else { return false }
        return artwork.id == source.last?.id
    }
    
    @ViewBuilder
    func showErrorView(message: String) -> some View {
        Text("Error: \(message)")
    }
}
