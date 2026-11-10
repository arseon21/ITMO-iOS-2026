#if DEBUG
import Foundation

enum UITestSupport {
    static var isEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITesting")
    }

    static func makeDefaults() -> UserDefaults {
        let name = "UITesting"
        let defaults = UserDefaults(suiteName: name) ?? .standard
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}

struct UITestMovieService: MovieServiceProtocol {
    private static let popular = [
        Movie(id: 258687, title: "Интерстеллар", year: 2014, posterURL: nil,
              genres: ["фантастика"], rating: 8.6, overview: "Описание фильма"),
        Movie(id: 447301, title: "Начало", year: 2010, posterURL: nil,
              genres: ["фантастика"], rating: 8.7, overview: "Описание фильма")
    ]

    private static let premieres = [
        Movie(id: 326, title: "Побег из Шоушенка", year: 1994, posterURL: nil,
              genres: ["драма"], rating: 9.1, overview: "Описание фильма")
    ]

    func fetchPopular() async throws -> [Movie] {
        Self.popular
    }

    func fetchPremieres() async throws -> [Movie] {
        Self.premieres
    }

    func fetchDetails(id: Int) async throws -> Movie {
        guard let movie = (Self.popular + Self.premieres).first(where: { $0.id == id }) else {
            throw APIError.badStatus(404)
        }
        return movie
    }
}
#endif
