import SwiftUI

@main
struct FilmRatingApp: App {
    private let service: any MovieServiceProtocol
    @State private var store: ReviewStore

    init() {
        #if DEBUG
        if UITestSupport.isEnabled {
            service = UITestMovieService()
            _store = State(initialValue: ReviewStore(defaults: UITestSupport.makeDefaults()))
            return
        }
        #endif
        service = KinopoiskMovieService(apiKey: Secrets.apiKey)
        _store = State(initialValue: ReviewStore())
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(service: service, store: store)
                    .tabItem { Label("Главная", systemImage: "film") }

                MyReviewsView(service: service, store: store)
                    .tabItem { Label("Мои оценки", systemImage: "star") }
            }
            .preferredColorScheme(.dark)
            .tint(.orange)
        }
    }
}
