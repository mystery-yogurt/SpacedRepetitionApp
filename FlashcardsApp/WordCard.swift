import Foundation

public struct WordCard: Identifiable, Equatable {
    public let id: UUID
    public var word: String
    public var transcription: String
    public var translation: String
    public var exampleUsage: String
    public var repetitionLevel: Int // Уровень запоминания от 0 до 5

    public init(
        id: UUID = UUID(),
        word: String,
        transcription: String,
        translation: String,
        exampleUsage: String,
        repetitionLevel: Int = 0
    ) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.exampleUsage = exampleUsage
        self.repetitionLevel = repetitionLevel
    }
}
