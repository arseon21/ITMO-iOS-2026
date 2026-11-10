import XCTest

final class FilmRatingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
        return app
    }

    @MainActor
    func testHomeShowsMoviesAndOpensDetails() {
        let app = launchApp()

        XCTAssertTrue(app.staticTexts["popularHeader"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["premieresHeader"].exists)

        let card = app.buttons["movieCard_258687"]
        XCTAssertTrue(card.exists)
        card.tap()

        let title = app.staticTexts["movieTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        XCTAssertEqual(title.label, "Интерстеллар")
    }

    @MainActor
    func testRateMovieAndSeeItInMyReviews() {
        let app = launchApp()

        let card = app.buttons["movieCard_258687"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()

        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        XCTAssertFalse(saveButton.isEnabled)

        app.buttons["star_8"].tap()
        XCTAssertTrue(saveButton.isEnabled)

        let reviewText = app.textViews["reviewText"]
        reviewText.tap()
        reviewText.typeText("Красиво и громко")
        saveButton.tap()

        let savedLabel = app.staticTexts["savedLabel"]
        XCTAssertTrue(savedLabel.waitForExistence(timeout: 2))
        XCTAssertTrue(savedLabel.label.contains("8"))

        app.tabBars.buttons["Мои оценки"].tap()
        let row = app.descendants(matching: .any)["reviewRow_258687"]
        XCTAssertTrue(row.waitForExistence(timeout: 3))
    }
}
