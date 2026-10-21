import Foundation
import RealmSwift

public class RealmDictionaryWord: Object {
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

public struct DictionaryWordDTO: Codable {
    public let word: String
    public let transcription: String
    public let translation: String
    public let exampleUsage: String
    public let frequencyRank: Int
}

/// Потокобезопасная структура для передачи в SwiftUI
public struct DictionaryWordItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let word: String
    public let transcription: String
    public let translation: String
    public let exampleUsage: String
    public let frequencyRank: Int

    public init(from realm: RealmDictionaryWord) {
        self.id = realm.id
        self.word = realm.word
        self.transcription = realm.transcription
        self.translation = realm.translation
        self.exampleUsage = realm.exampleUsage
        self.frequencyRank = realm.frequencyRank
    }

    public init(word: String, transcription: String, translation: String, exampleUsage: String, frequencyRank: Int = 0) {
        self.id = UUID().uuidString
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.exampleUsage = exampleUsage
        self.frequencyRank = frequencyRank
    }
}
