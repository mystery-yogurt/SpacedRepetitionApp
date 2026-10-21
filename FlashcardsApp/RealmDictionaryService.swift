import Foundation
import RealmSwift

/// Сервис управления вспомогательной нереляционной БД Realm
public final class RealmDictionaryService: ObservableObject {
    public static let shared = RealmDictionaryService()

    @Published public var isReady: Bool = false
    @Published public var wordsCount: Int = 0

    private var realmConfig: Realm.Configuration

    private init() {
        self.realmConfig = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true
        )
        Task {
            await initializeDictionary()
        }
    }

    public func getRealm() throws -> Realm {
        try Realm(configuration: realmConfig)
    }

    /// Инициализация и первичное наполнение базой из 1000 слов
    public func initializeDictionary() async {
        do {
            let realm = try await Realm(configuration: realmConfig, actor: MainActor.shared)
            let count = realm.objects(RealmDictionaryWord.self).count

            if count < 1000 {
                let dtos = RealmSeedDataGenerator.generate1000Words()
                try realm.write {
                    realm.delete(realm.objects(RealmDictionaryWord.self))
                    for dto in dtos {
                        let entity = RealmDictionaryWord(
                            word: dto.word,
                            transcription: dto.transcription,
                            translation: dto.translation,
                            exampleUsage: dto.exampleUsage,
                            frequencyRank: dto.frequencyRank
                        )
                        realm.add(entity)
                    }
                }
            }

            let finalCount = realm.objects(RealmDictionaryWord.self).count
            await MainActor.run {
                self.wordsCount = finalCount
                self.isReady = true
            }
        } catch {
            print("Realm init error: \(error)")
        }
    }

    /// Поиск точного совпадения слова для автозаполнения
    public func lookup(word: String) -> RealmDictionaryWord? {
        guard let realm = try? getRealm() else { return nil }
        let clean = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return realm.objects(RealmDictionaryWord.self)
            .filter("word ==[c] %@", clean)
            .first
    }

    /// Полнотекстовый/префиксный поиск по офлайн-словарю
    public func search(query: String, limit: Int = 50) -> [RealmDictionaryWord] {
        guard let realm = try? getRealm() else { return [] }
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Array(realm.objects(RealmDictionaryWord.self).sorted(byKeyPath: "frequencyRank").prefix(limit))
        }
        let clean = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let results = realm.objects(RealmDictionaryWord.self)
            .filter("word CONTAINS[c] %@ OR translation CONTAINS[c] %@", clean, clean)
            .sorted(byKeyPath: "frequencyRank")
        return Array(results.prefix(limit))
    }
}
