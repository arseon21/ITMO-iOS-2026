import Foundation

protocol MovieServiceProtocol: Sendable {
    func fetchPopular() async throws -> [Movie]
    func fetchPremieres() async throws -> [Movie]
    func fetchDetails(id: Int) async throws -> Movie
}
