import SwiftUI
import SwiftData

@main
struct FlashcardsApp: App {
    let container: ModelContainer

    init() {
        self.container = Self.makeModelContainer()
    }

    @MainActor
    private static func makeModelContainer() -> ModelContainer {
        let schema = Schema([
            DeckEntity.self,
            CardEntity.self,
            DailyProgressEntity.self
        ])

        let container: ModelContainer
        do {
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("Предупреждение: не удалось загрузить SQLite хранилище: \(error). Переключение на in-memory.")
            let inMemConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                container = try ModelContainer(for: schema, configurations: [inMemConfig])
            } catch {
                fatalError("Критическая ошибка создания ModelContainer: \(error)")
            }
        }

        // Первичное наполнение данными до старта первого экрана
        DataSeeder.seedInitialDataIfNeeded(context: container.mainContext)
        return container
    }

    var body: some Scene {
        WindowGroup {
            MainDashboardView()
        }
        .modelContainer(container)
    }
}
