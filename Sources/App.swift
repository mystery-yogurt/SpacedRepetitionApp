import SwiftUI
import SwiftData
import RealmSwift
import UserNotifications

@main
struct SpacedRepetitionApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = SwiftData.Schema([UserWord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        seedRealmDatabase()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func seedRealmDatabase() {
        do {
            let realm = try Realm()
            if realm.objects(BaseWord.self).isEmpty {
                try realm.write {
                    realm.add(BaseWord(word: "hello", translation: "привет", transcription: "[həˈləʊ]", example: "Hello world"))
                    realm.add(BaseWord(word: "github", translation: "гитхаб", transcription: "[gɪthʌb]", example: "Compiled on GitHub"))
                }
            }
        } catch {}
    }
}
