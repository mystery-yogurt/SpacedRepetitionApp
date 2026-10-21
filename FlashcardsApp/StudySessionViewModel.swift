import Foundation
import SwiftUI
import SwiftData

@MainActor
public final class StudySessionViewModel: ObservableObject {
    @Published public var cards: [CardEntity] = []
    @Published public var currentIndex: Int = 0
    @Published public var isCardFlipped: Bool = false
    @Published public var isCompleted: Bool = false

    private var modelContext: ModelContext?

    public init() {}

    public func configure(with context: ModelContext) {
        self.modelContext = context
        loadDueCards()
    }

    public var currentCard: WordCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex].toWordCard()
    }

    public var currentCardEntity: CardEntity? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    public var progressText: String {
        guard !cards.isEmpty else { return "0/0" }
        return "\(currentIndex + 1) из \(cards.count)"
    }

    public func rateCurrentCard(rating: Int) {
        guard currentIndex < cards.count, let context = modelContext else { return }

        let entity = cards[currentIndex]
        // Применяем математическую модель SM-2
        entity.applySM2Review(rating: rating)

        try? context.save()

        withAnimation {
            isCardFlipped = false
            if currentIndex + 1 < cards.count {
                currentIndex += 1
            } else {
                isCompleted = true
            }
        }
    }

    private func loadDueCards() {
        guard let context = modelContext else { return }
        let now = Date()
        let fetchDescriptor = FetchDescriptor<CardEntity>(
            predicate: #Predicate<CardEntity> { card in
                card.nextDueDate <= now
            },
            sortBy: [SortDescriptor(\CardEntity.nextDueDate, order: .forward)]
        )

        let fetched = (try? context.fetch(fetchDescriptor)) ?? []
        if fetched.isEmpty {
            // Если на сегодня нет карточек, берем любые 5 для тренировки
            let allFetch = FetchDescriptor<CardEntity>(sortBy: [SortDescriptor(\CardEntity.word)])
            self.cards = Array(((try? context.fetch(allFetch)) ?? []).prefix(5))
        } else {
            self.cards = fetched
        }
    }
}
