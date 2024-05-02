import SwiftUI

struct ArtworkRowView: View {
    var artwork: Artwork
    
    var body: some View {
        HStack {
            artworkThumbnail(artwork)
            VStack(alignment: .leading) {
                Text(artwork.title).bold()
                Text(artwork.artistDisplay).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func artworkThumbnail(_ artwork: Artwork) -> some View {
        if let url = artwork.iiifImageUrl {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure:
                    Image(systemName: "photo") 
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .frame(width: 100, height: 100)
        }
    }
}
