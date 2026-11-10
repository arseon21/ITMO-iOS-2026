import Foundation
import Observation

@MainActor
protocol ReviewStoring: AnyObject {
    func review(for movieID: Int) -> Review?
    func save(_ review: Review)
    func deleteReview(for movieID: Int)
}

@MainActor
@Observable
final class ReviewStore: ReviewStoring {
    private let key = "reviews"
    private let defaults: UserDefaults
    private(set) var reviews: [Int: Review] = [:]

    var sortedReviews: [Review] {
        reviews.values.sorted { $0.date > $1.date }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let saved = try? JSONDecoder().decode([Review].self, from: data) {
            for review in saved {
                reviews[review.id] = review
            }
        }
    }

    func review(for movieID: Int) -> Review? {
        reviews[movieID]
    }

    func save(_ review: Review) {
        reviews[review.id] = review
        persist()
    }

    func deleteReview(for movieID: Int) {
        reviews[movieID] = nil
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(Array(reviews.values)) {
            defaults.set(data, forKey: key)
        }
    }
}
