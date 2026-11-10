import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    private let service: any MovieServiceProtocol
    private let store: ReviewStore

    init(service: any MovieServiceProtocol, store: ReviewStore) {
        self.service = service
        self.store = store
        _viewModel = State(initialValue: HomeViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Фильмы")
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailView(movie: movie, service: service, store: store)
                }
                .task { await viewModel.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Загрузка…")
        case .failed(let message):
            ContentUnavailableView {
                Label("Не удалось загрузить", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Повторить") {
                    Task { await viewModel.load() }
                }
            }
        case .loaded:
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    section(title: "Популярное", movies: viewModel.popular, id: "popularHeader")
                    section(title: "Премьеры месяца", movies: viewModel.premieres, id: "premieresHeader")
                }
                .padding(.vertical)
            }
        }
    }

    private func section(title: String, movies: [Movie], id: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal)
                .accessibilityIdentifier(id)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MovieCard(movie: movie, userRating: store.review(for: movie.id)?.rating)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("movieCard_\(movie.id)")
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MovieCard: View {
    let movie: Movie
    let userRating: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            PosterView(url: movie.posterURL)
                .frame(width: 130, height: 195)
                .overlay(alignment: .topLeading) {
                    if let rating = movie.rating {
                        RatingBadge(rating: rating).padding(6)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if let userRating {
                        UserRatingBadge(rating: userRating).padding(6)
                    }
                }

            Text(movie.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2, reservesSpace: true)
            Text(movie.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 130, alignment: .leading)
    }
}
