import SwiftUI

struct PosterView: View {
    let url: URL?

    var body: some View {
        Color.gray.opacity(0.2)
            .overlay {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "film")
                        .foregroundStyle(.secondary)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        Text(rating, format: .number.precision(.fractionLength(1)))
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(rating >= 7 ? Color.green : Color.gray, in: RoundedRectangle(cornerRadius: 6))
    }
}

struct UserRatingBadge: View {
    let rating: Int

    var body: some View {
        Label("\(rating)", systemImage: "star.fill")
            .font(.caption.bold())
            .foregroundStyle(.black)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.orange, in: Capsule())
    }
}

struct RatingStars: View {
    @Binding var rating: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...10, id: \.self) { value in
                Button {
                    rating = value
                } label: {
                    Image(systemName: value <= rating ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundStyle(Color.orange)
                        .frame(maxWidth: .infinity, minHeight: 36)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("star_\(value)")
            }
        }
    }
}
