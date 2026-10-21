import Foundation
import RealmSwift

/// Модель нереляционного вспомогательного хранилища Realm
public class RealmDictionaryWord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted(indexed: true) public var word: String = ""
    @Persisted public var transcription: String = ""
    @Persisted public var translation: String = ""
    @Persisted public var exampleUsage: String = ""
    @Persisted public var frequencyRank: Int = 0

    public convenience init(
        word: String,
        transcription: String,
        translation: String,
        exampleUsage: String,
        frequencyRank: Int
    ) {
        self.init()
        self.id = UUID().uuidString
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.exampleUsage = exampleUsage
        self.frequencyRank = frequencyRank
    }
}

/// DTO для десериализации внешнего JSON формата
public struct DictionaryWordDTO: Codable {
    public let word: String
    public let transcription: String
    public let translation: String
    public let exampleUsage: String
    public let frequencyRank: Int
}
