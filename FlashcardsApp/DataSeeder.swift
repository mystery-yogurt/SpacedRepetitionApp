import Foundation
import SwiftData

/// Первичное заполнение основной реляционной БД SwiftData
public enum DataSeeder {
    @MainActor
    public static func seedInitialDataIfNeeded(context: ModelContext) {
        let deckFetch = FetchDescriptor<DeckEntity>()
        let existingDecks = (try? context.fetch(deckFetch)) ?? []

        guard existingDecks.isEmpty else { return }

        // 1. Создаем колоды
        let generalDeck = DeckEntity(
            title: "General English",
            deckDescription: "Повседневная лексика и популярные выражения",
            iconName: "book.fill"
        )
        let itDeck = DeckEntity(
            title: "IT & Software",
            deckDescription: "Архитектура, базы данных и разработка ПО",
            iconName: "chevron.left.forwardslash.chevron.right"
        )
        let travelDeck = DeckEntity(
            title: "Travel & Airport",
            deckDescription: "Лексика для путешествий и аэропорта",
            iconName: "airplane"
        )

        context.insert(generalDeck)
        context.insert(itDeck)
        context.insert(travelDeck)

        // 2. Создаем карточки со значениями SM-2
        let cards: [CardEntity] = [
            CardEntity(
                word: "Resilient",
                transcription: "[rɪˈzɪl.jənt]",
                translation: "Стойкий, жизнерадостный",
                exampleUsage: "Babies are generally remarkably resilient.",
                repetitionLevel: 2,
                easinessFactor: 2.5,
                intervalDays: 1,
                repetitions: 1,
                nextDueDate: Date(),
                deck: generalDeck
            ),
            CardEntity(
                word: "Ubiquitous",
                transcription: "[juːˈbɪk.wə.təs]",
                translation: "Вездесущий, повсеместный",
                exampleUsage: "Smartphones have become ubiquitous in daily life.",
                repetitionLevel: 4,
                easinessFactor: 2.6,
                intervalDays: 6,
                repetitions: 2,
                nextDueDate: Date(),
                deck: generalDeck
            ),
            CardEntity(
                word: "Ephemeral",
                transcription: "[ɪˈfem.ər.əl]",
                translation: "Эфемерный, недолговечный",
                exampleUsage: "Fame in the digital age is often ephemeral.",
                repetitionLevel: 1,
                easinessFactor: 2.3,
                intervalDays: 1,
                repetitions: 0,
                nextDueDate: Date(),
                deck: generalDeck
            ),
            CardEntity(
                word: "Concurrency",
                transcription: "[kənˈkʌr.ən.si]",
                translation: "Конкурентность, параллелизм",
                exampleUsage: "Swift Concurrency provides safe async programming.",
                repetitionLevel: 3,
                easinessFactor: 2.5,
                intervalDays: 3,
                repetitions: 1,
                nextDueDate: Date(),
                deck: itDeck
            ),
            CardEntity(
                word: "Serialization",
                transcription: "[ˌsɪə.ri.ə.laɪˈzeɪ.ʃən]",
                translation: "Сериализация данных",
                exampleUsage: "JSONEncoder handles object serialization.",
                repetitionLevel: 5,
                easinessFactor: 2.7,
                intervalDays: 10,
                repetitions: 3,
                nextDueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                deck: itDeck
            )
        ]

        for card in cards {
            context.insert(card)
        }

        // 3. Заполняем статистику изученных слов за неделю (Swift Charts)
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let counts = [12, 18, 8, 25, 14, 30, 22]
        let calendar = Calendar.current

        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -(6 - i), to: Date()) ?? Date()
            let progress = DailyProgressEntity(
                dayOfWeek: weekdays[i],
                wordsLearned: counts[i],
                date: date
            )
            context.insert(progress)
        }

        try? context.save()
    }
}
