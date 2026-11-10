@testable import FilmRating
import Foundation

@MainActor
final class MockReviewStore: ReviewStoring {
    private(set) var reviews: [Int: Review] = [:]
    private(set) var saveCallCount = 0

    func review(for movieID: Int) -> Review? {
        reviews[movieID]
    }

    func save(_ review: Review) {
        saveCallCount += 1
        reviews[review.id] = review
    }

    func deleteReview(for movieID: Int) {
        reviews[movieID] = nil
    }
}
