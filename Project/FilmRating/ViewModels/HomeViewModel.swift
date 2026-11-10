import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: LoadState = .loading
    private(set) var popular: [Movie] = []
    private(set) var premieres: [Movie] = []

    private let service: any MovieServiceProtocol

    init(service: any MovieServiceProtocol) {
        self.service = service
    }

    func load() async {
        guard state != .loaded else { return }
        state = .loading
        let service = self.service

        do {
            async let popularRequest = service.fetchPopular()
            async let premieresRequest = service.fetchPremieres()
            let (popular, premieres) = try await (popularRequest, premieresRequest)

            self.popular = popular
            self.premieres = premieres
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
