import Foundation
import RealmSwift

public final class RealmDictionaryService: ObservableObject {
    public static let shared = RealmDictionaryService()

    @Published public var isReady: Bool = false
    @Published public var wordsCount: Int = 0

    private var realmConfig: Realm.Configuration

    public init() {
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = true
        config.objectTypes = [RealmDictionaryWord.self]
        self.realmConfig = config
    }

    private func getRealm() -> Realm? {
        if let realm = try? Realm(configuration: realmConfig) {
            return realm
        }
        var inMemoryConfig = Realm.Configuration()
        inMemoryConfig.inMemoryIdentifier = "OfflineDictionaryBackup"
        inMemoryConfig.objectTypes = [RealmDictionaryWord.self]
        return try? Realm(configuration: inMemoryConfig)
    }

    public func initializeDictionaryIfNeeded() {
        guard !isReady else { return }

        guard let realm = getRealm() else {
            print("Не удалось открыть Realm")
            return
        }

        let count = realm.objects(RealmDictionaryWord.self).count
        if count < 1000 {
            let dtos = RealmSeedDataGenerator.generate1000Words()
            do {
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
            } catch {
                print("Ошибка записи в Realm: \(error)")
            }
        }

        let finalCount = (getRealm())?.objects(RealmDictionaryWord.self).count ?? 0
        DispatchQueue.main.async {
            self.wordsCount = finalCount
            self.isReady = true
        }
    }

    public func lookup(word: String) -> DictionaryWordItem? {
        guard let realm = getRealm() else { return nil }
        let clean = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !clean.isEmpty else { return nil }

        if let match = realm.objects(RealmDictionaryWord.self).filter("word ==[c] %@", clean).first {
            return DictionaryWordItem(from: match)
        }
        return nil
    }

    public func search(query: String, limit: Int = 50) -> [DictionaryWordItem] {
        guard let realm = getRealm() else { return [] }
        let clean = query.trimmingCharacters(in: .whitespacesAndNewlines)

        let results: Results<RealmDictionaryWord>
        if clean.isEmpty {
            results = realm.objects(RealmDictionaryWord.self).sorted(byKeyPath: "frequencyRank")
        } else {
            results = realm.objects(RealmDictionaryWord.self)
                .filter("word CONTAINS[c] %@ OR translation CONTAINS[c] %@", clean, clean)
                .sorted(byKeyPath: "frequencyRank")
        }

        return Array(results.prefix(limit)).map { DictionaryWordItem(from: $0) }
    }
}
