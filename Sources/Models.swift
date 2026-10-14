import Foundation
import SwiftData
import RealmSwift

@Model
final class UserWord {
    var id: UUID = UUID()
    var word: String
    var translation: String
    var transcription: String
    var example: String

    var repetitions: Int = 0
    var interval: Int = 0
    var easeFactor: Double = 2.5
    var nextReviewDate: Date
    
    init(word: String, translation: String, transcription: String = "", example: String = "") {
        self.word = word
        self.translation = translation
        self.transcription = transcription
        self.example = example
        self.nextReviewDate = Date()
    }
}

class BaseWord: Object {
    @Persisted(primaryKey: true) var word: String
    @Persisted var translation: String
    @Persisted var transcription: String
    @Persisted var example: String
    
    convenience init(word: String, translation: String, transcription: String, example: String) {
        self.init()
        self.word = word
        self.translation = translation
        self.transcription = transcription
        self.example = example
    }
}
