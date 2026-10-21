import Foundation
import SwiftData

@Model
public final class DeckEntity {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var deckDescription: String
    public var iconName: String
    public var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \CardEntity.deck)
    public var cards: [CardEntity] = []

    public init(
        id: UUID = UUID(),
        title: String,
        deckDescription: String,
        iconName: String = "book.fill",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.deckDescription = deckDescription
        self.iconName = iconName
        self.createdAt = createdAt
    }

    public var dueCardsCount: Int {
        let now = Date()
        return cards.filter { $0.nextDueDate <= now }.count
    }
}

@Model
public final class CardEntity {
    @Attribute(.unique) public var id: UUID
    public var word: String
    public var transcription: String
    public var translation: String
    public var exampleUsage: String

    // SM-2 параметры и интервалы повторений
    public var repetitionLevel: Int      // 0 - 5
    public var easinessFactor: Double    // SM-2 EF, по умолчанию 2.5
    public var intervalDays: Int         // Текущий интервал в днях
    public var repetitions: Int          // Число успешных повторений подряд
    public var nextDueDate: Date         // Точная дата следующего повтора
    public var lastReviewedDate: Date?

    public var deck: DeckEntity?

    public init(
        id: UUID = UUID(),
        word: String,
        transcription: String,
        translation: String,
        exampleUsage: String,
        repetitionLevel: Int = 0,
        easinessFactor: Double = 2.5,
        intervalDays: Int = 0,
        repetitions: Int = 0,
        nextDueDate: Date = Date(),
        lastReviewedDate: Date? = nil,
        deck: DeckEntity? = nil
    ) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.exampleUsage = exampleUsage
        self.repetitionLevel = repetitionLevel
        self.easinessFactor = easinessFactor
        self.intervalDays = intervalDays
        self.repetitions = repetitions
        self.nextDueDate = nextDueDate
        self.lastReviewedDate = lastReviewedDate
        self.deck = deck
    }

    /// Преобразование в UI-модель WordCard
    public func toWordCard() -> WordCard {
        WordCard(
            id: id,
            word: word,
            transcription: transcription,
            translation: translation,
            exampleUsage: exampleUsage,
            repetitionLevel: repetitionLevel
        )
    }

    /// Расчет интервала по алгоритму SuperMemo SM-2
    public func applySM2Review(rating: Int) {
        let clampedRating = min(max(rating, 0), 5)
        self.repetitionLevel = clampedRating
        self.lastReviewedDate = Date()

        if clampedRating >= 3 {
            if repetitions == 0 {
                intervalDays = 1
            } else if repetitions == 1 {
                intervalDays = 6
            } else {
                intervalDays = Int(round(Double(intervalDays) * easinessFactor))
            }
            repetitions += 1
        } else {
            repetitions = 0
            intervalDays = 1
        }

        // Обновление коэффициента забывания/легкости (EF)
        let q = Double(clampedRating)
        let newEF = easinessFactor + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02))
        self.easinessFactor = max(newEF, 1.3)

        // Вычисление даты следующего показа
        self.nextDueDate = Calendar.current.date(
            byAdding: .day,
            value: intervalDays,
            to: Date()
        ) ?? Date().addingTimeInterval(Double(intervalDays * 86400))
    }
}

@Model
public final class DailyProgressEntity {
    @Attribute(.unique) public var id: UUID
    public var dayOfWeek: String
    public var wordsLearned: Int
    public var date: Date

    public init(id: UUID = UUID(), dayOfWeek: String, wordsLearned: Int, date: Date = Date()) {
        self.id = id
        self.dayOfWeek = dayOfWeek
        self.wordsLearned = wordsLearned
        self.date = date
    }
}
