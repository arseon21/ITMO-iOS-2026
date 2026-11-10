@testable import FilmRating
import Foundation

struct MockMovieService: MovieServiceProtocol {
    static let popular = [
        Movie(id: 1, title: "Интерстеллар", year: 2014, posterURL: nil,
              genres: ["фантастика"], rating: 8.6, overview: "Описание"),
        Movie(id: 2, title: "Начало", year: 2010, posterURL: nil,
              genres: ["фантастика"], rating: 8.7, overview: "Описание")
    ]

    static let premieres = [
        Movie(id: 3, title: "Побег из Шоушенка", year: 1994, posterURL: nil,
              genres: ["драма"], rating: 9.1, overview: "Описание")
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
