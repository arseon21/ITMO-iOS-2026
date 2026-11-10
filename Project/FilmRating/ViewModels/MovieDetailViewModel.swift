import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    private(set) var movie: Movie
    var rating: Int
    var text: String

    private let service: any MovieServiceProtocol
    private let store: any ReviewStoring

    init(movie: Movie, service: any MovieServiceProtocol, store: any ReviewStoring) {
        let saved = store.review(for: movie.id)
        self.movie = movie
        self.service = service
        self.store = store
        self.rating = saved?.rating ?? 0
        self.text = saved?.text ?? ""
    }

    var savedReview: Review? {
        store.review(for: movie.id)
    }

    var canSave: Bool {
        (1...10).contains(rating)
    }

    func loadDetails() async {
        guard movie.overview == nil else { return }
        let service = self.service
        let id = movie.id
        if let details = try? await service.fetchDetails(id: id) {
            movie = details
        }
    }

    func save() {
        guard canSave else { return }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        store.save(Review(movie: movie, rating: rating, text: text, date: Date()))
    }

    func delete() {
        store.deleteReview(for: movie.id)
        rating = 0
        text = ""
    }
}
