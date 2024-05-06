import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var model: MainViewModel
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Artworks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle("Show Favorites", isOn: $model.showFavoritesOnly)
                        .onChange(of: model.showFavoritesOnly) {
                            model.toggleFavorites()
                        }
                }
            }
        }
        .onAppear {
            Task {
                await model.fetchInitialData()
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
                NavigationLink(destination: DetailView(viewContext: model.viewContext, artwork: artwork)) {
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
        return artwork.id == source.last?.id
    }
    
    @ViewBuilder
    func showErrorView(message: String) -> some View {
        Text("Error: \(message)")
    }
}
