import Foundation

enum APIError: LocalizedError {
    case badURL
    case badStatus(Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Некорректный адрес запроса."
        case .badStatus(401):
            return "Неверный API-ключ."
        case .badStatus(402):
            return "Дневной лимит запросов исчерпан."
        case .badStatus(let code):
            return "Ошибка сервера (код \(code))."
        case .decoding:
            return "Не удалось разобрать ответ сервера."
        }
    }
}

struct APIClient: Sendable {
    private let baseURL = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films")
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func get<T: Decodable>(_ path: String, query: [String: String] = [:]) async throws -> T {
        guard let baseURL,
              var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false) else {
            throw APIError.badURL
        }
        if !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        let (data, response) = try await session.data(for: request)

        let code = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(code) else {
            throw APIError.badStatus(code)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
