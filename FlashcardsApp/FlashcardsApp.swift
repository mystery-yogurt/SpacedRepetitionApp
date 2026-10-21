import SwiftUI
import SwiftData

@main
struct FlashcardsApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                DeckEntity.self,
                CardEntity.self,
                DailyProgressEntity.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }

        // Фоновый разогрев вспомогательной БД Realm (1000 слов)
        _ = RealmDictionaryService.shared
    }

    var body: some Scene {
        WindowGroup {
            MainDashboardView()
                .modelContainer(modelContainer)
        }
    }
}
