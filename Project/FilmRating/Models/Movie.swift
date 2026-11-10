import Foundation

struct Movie: Identifiable, Hashable, Codable, Sendable {
    let id: Int
    let title: String
    let year: Int?
    let posterURL: URL?
    let genres: [String]
    let rating: Double?
    let overview: String?

    var subtitle: String {
        var parts: [String] = []
        if let year {
            parts.append(String(year))
        }
        if let genre = genres.first {
            parts.append(genre)
        }
        return parts.joined(separator: " · ")
    }
}
