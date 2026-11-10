import SwiftUI

struct MyReviewsView: View {
    let service: any MovieServiceProtocol
    let store: ReviewStore

    var body: some View {
        NavigationStack {
            Group {
                if store.sortedReviews.isEmpty {
                    ContentUnavailableView(
                        "Пока нет оценок",
                        systemImage: "star",
                        description: Text("Откройте фильм на главной и поставьте оценку.")
                    )
                } else {
                    List {
                        ForEach(store.sortedReviews) { review in
                            NavigationLink(value: review.movie) {
                                ReviewRow(review: review)
                            }
                            .accessibilityIdentifier("reviewRow_\(review.id)")
                        }
                        .onDelete { offsets in
                            let reviews = store.sortedReviews
                            for index in offsets {
                                store.deleteReview(for: reviews[index].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Мои оценки")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie, service: service, store: store)
            }
        }
    }
}

struct ReviewRow: View {
    let review: Review

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            PosterView(url: review.movie.posterURL)
                .frame(width: 50, height: 75)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(review.movie.title)
                        .font(.headline)
                    Spacer()
                    UserRatingBadge(rating: review.rating)
                }
                if !review.text.isEmpty {
                    Text(review.text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
    }
}
