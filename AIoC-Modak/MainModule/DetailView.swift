import SwiftUI
import CoreData

struct DetailView: View {
    var viewContext: NSManagedObjectContext
    let artwork: Artwork
    
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = artwork.iiifImageUrl {
                    AsyncImage(url: imageUrl) { phase in
                        phase
                            .image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                }
                
                Text(artwork.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("By: \(artwork.artistDisplay)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Date: \(artwork.dateDisplay)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let placeOfOrigin = artwork.placeOfOrigin {
                    Text("Place of Origin: \(placeOfOrigin)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let dimensions = artwork.dimensions {
                    Text("Dimensions: \(dimensions)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Medium: \(artwork.mediumDisplay)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Additional Information")
                        .font(.headline)
                        .padding(.top, 10)
                        .foregroundColor(.primary)
                    
                    Divider()
                    
                    if !artwork.artworkTypeTitle.isEmpty {
                        HStack {
                            Text("Type:")
                                .fontWeight(.bold)
                            Text(artwork.artworkTypeTitle)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if !artwork.termTitles.isEmpty {
                        HStack {
                            Text("Terms:")
                                .fontWeight(.bold)
                            Text(artwork.termTitles.joined(separator: ", "))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(artwork.title)
        .toolbar {
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
        }
        .onAppear {
            isFavorite = isArtworkFavorite()
        }
    }
    
    private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            saveArtworkToFavorites()
        } else {
            removeArtworkFromFavorites()
        }
    }
    
    private func saveArtworkToFavorites() {
        let favoriteArtwork = FavoriteArtwork(context: viewContext)
        favoriteArtwork.id = Int64(artwork.id)
        favoriteArtwork.title = artwork.title
        favoriteArtwork.imageId = artwork.imageId
        favoriteArtwork.artistDisplay = artwork.artistDisplay
        favoriteArtwork.placeOfOrigin = artwork.placeOfOrigin
        favoriteArtwork.dateDisplay = artwork.dateDisplay
        favoriteArtwork.dimensions = artwork.dimensions
        favoriteArtwork.mediumDisplay = artwork.mediumDisplay
        favoriteArtwork.isPublicDomain = artwork.isPublicDomain
        favoriteArtwork.isOnView = artwork.isOnView
        favoriteArtwork.artworkTypeTitle = artwork.artworkTypeTitle
        favoriteArtwork.termTitles = artwork.termTitles
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func removeArtworkFromFavorites() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteArtwork")
        fetchRequest.predicate = NSPredicate(format: "id == %d", artwork.id)
        
        do {
            let favoriteArtworks = try viewContext.fetch(fetchRequest) as? [FavoriteArtwork]
            for favoriteArtwork in favoriteArtworks ?? [] {
                viewContext.delete(favoriteArtwork)
            }
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func isArtworkFavorite() -> Bool {        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteArtwork")
        fetchRequest.predicate = NSPredicate(format: "id == %d", artwork.id)
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            return false
        }
    }

}
