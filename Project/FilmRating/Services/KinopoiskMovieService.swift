import Foundation

struct KinopoiskMovieService: MovieServiceProtocol {
    private let client: APIClient

    init(apiKey: String) {
        client = APIClient(apiKey: apiKey)
    }

    func fetchPopular() async throws -> [Movie] {
        let list: MovieListDTO = try await client.get(
            "collections",
            query: ["type": "TOP_POPULAR_MOVIES"]
        )
        return list.items.map { $0.toMovie() }
    }

    func fetchPremieres() async throws -> [Movie] {
        let months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
                      "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)

        let list: MovieListDTO = try await client.get(
            "premieres",
            query: ["year": String(year), "month": months[month - 1]]
        )
        return list.items.prefix(20).map { $0.toMovie() }
    }

    func fetchDetails(id: Int) async throws -> Movie {
        let dto: MovieDTO = try await client.get(String(id))
        return dto.toMovie()
    }
}
