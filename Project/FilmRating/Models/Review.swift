import Foundation

struct Review: Identifiable, Codable, Equatable, Sendable {
    let movie: Movie
    var rating: Int
    var text: String
    var date: Date

    var id: Int {
        movie.id
    }
}
