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
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("Ошибка загрузки постоянного хранилища: \(error). Запуск в памяти.")
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            self.container = (try? ModelContainer(for: schema, configurations: [fallbackConfig]))
                ?? (try! ModelContainer(for: schema))
        }
    }

    var body: some Scene {
        WindowGroup {
            MainDashboardView()
        }
        .modelContainer(container)
    }
}
