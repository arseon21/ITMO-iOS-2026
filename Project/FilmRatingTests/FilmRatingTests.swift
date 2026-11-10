@testable import FilmRating
import XCTest

final class FilmRatingTests: XCTestCase {

    @MainActor
    func testHomeLoadsMovies() async {
        let viewModel = HomeViewModel(service: MockMovieService())

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.popular.count, MockMovieService.popular.count)
        XCTAssertEqual(viewModel.premieres.count, MockMovieService.premieres.count)
        XCTAssertEqual(viewModel.popular.first?.title, "Интерстеллар")
    }

    @MainActor
    func testReviewIsSaved() {
        let store = MockReviewStore()
        let movie = MockMovieService.popular[0]
        let viewModel = MovieDetailViewModel(movie: movie, service: MockMovieService(), store: store)

        XCTAssertFalse(viewModel.canSave)

        viewModel.rating = 8
        viewModel.text = "  Красиво и громко  "
        XCTAssertTrue(viewModel.canSave)
        viewModel.save()

        let saved = store.review(for: movie.id)
        XCTAssertEqual(store.saveCallCount, 1)
        XCTAssertEqual(saved?.rating, 8)
        XCTAssertEqual(saved?.text, "Красиво и громко")
        XCTAssertEqual(saved?.movie, movie)
    }
}
