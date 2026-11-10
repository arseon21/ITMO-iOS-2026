import Foundation

struct MovieListDTO: Decodable {
    let items: [MovieDTO]
}

struct MovieDTO: Decodable {
    struct Genre: Decodable {
        let genre: String
    }

    let kinopoiskId: Int
    let nameRu: String?
    let nameOriginal: String?
    let nameEn: String?
    let year: Int?
    let posterUrlPreview: String?
    let ratingKinopoisk: Double?
    let genres: [Genre]?
    let description: String?

    func toMovie() -> Movie {
        let poster = posterUrlPreview?.replacingOccurrences(of: "http://", with: "https://")
        return Movie(
            id: kinopoiskId,
            title: nameRu ?? nameOriginal ?? nameEn ?? "Без названия",
            year: year,
            posterURL: poster.flatMap { URL(string: $0) },
            genres: genres?.map(\.genre) ?? [],
            rating: ratingKinopoisk,
            overview: description
        )
    }
}
