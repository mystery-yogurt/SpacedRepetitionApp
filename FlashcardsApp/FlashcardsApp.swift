import SwiftUI
import SwiftData

@main
struct FlashcardsApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            DeckEntity.self,
            CardEntity.self,
            DailyProgressEntity.self
        ])
        
        do {
            self.container = try ModelContainer(for: schema)
        } catch {
            print("Предупреждение: создание стандартного хранилища завершилось с \(error). Запуск с конфигурацией в памяти.")
            let inMemoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                self.container = try ModelContainer(for: schema, configurations: [inMemoryConfig])
            } catch {
                fatalError("Не удалось создать ModelContainer: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            MainDashboardView()
        }
        .modelContainer(container)
    }
}
