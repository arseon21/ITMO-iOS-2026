import SwiftUI

struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel
    @FocusState private var isEditingText: Bool

    init(movie: Movie, service: any MovieServiceProtocol, store: ReviewStore) {
        let viewModel = MovieDetailViewModel(movie: movie, service: service, store: store)
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if let overview = viewModel.movie.overview {
                    Text(overview)
                }

                Divider()

                Text("Ваша оценка")
                    .font(.headline)
                RatingStars(rating: $viewModel.rating)

                Text("Рецензия")
                    .font(.headline)
                TextEditor(text: $viewModel.text)
                    .focused($isEditingText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 140)
                    .padding(8)
                    .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                    .accessibilityIdentifier("reviewText")

                if let saved = viewModel.savedReview {
                    HStack {
                        Text("Сохранено: \(saved.rating) из 10")
                            .foregroundStyle(.green)
                            .accessibilityIdentifier("savedLabel")
                        Spacer()
                        Button("Удалить", role: .destructive) {
                            viewModel.delete()
                        }
                        .accessibilityIdentifier("deleteButton")
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Сохранить") {
                isEditingText = false
                viewModel.save()
            }
            .disabled(!viewModel.canSave)
            .accessibilityIdentifier("saveButton")
        }
        .task { await viewModel.loadDetails() }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            PosterView(url: viewModel.movie.posterURL)
                .frame(width: 110, height: 165)

            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.movie.title)
                    .font(.title2.bold())
                    .accessibilityIdentifier("movieTitle")
                Text(viewModel.movie.subtitle)
                    .foregroundStyle(.secondary)
                if let rating = viewModel.movie.rating {
                    RatingBadge(rating: rating)
                }
            }
        }
    }
}
