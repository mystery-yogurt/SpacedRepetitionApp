import Foundation
import SwiftUI

public final class StudySessionViewModel: ObservableObject {
    @Published public var cards: [WordCard] = []
    @Published public var currentIndex: Int = 0
    @Published public var isCardFlipped: Bool = false
    @Published public var isCompleted: Bool = false

    public init() {
        loadMockCards()
    }

    public var currentCard: WordCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    public var progressText: String {
        guard !cards.isEmpty else { return "0/0" }
        return "\(currentIndex + 1) из \(cards.count)"
    }

    public func rateCurrentCard(rating: Int) {
        guard currentIndex < cards.count else { return }

        // Обновляем уровень запоминания (0 - 5)
        cards[currentIndex].repetitionLevel = min(max(rating, 0), 5)

        // Переход к следующей карточке
        withAnimation {
            isCardFlipped = false
            if currentIndex + 1 < cards.count {
                currentIndex += 1
            } else {
                isCompleted = true
            }
        }
    }

    private func loadMockCards() {
        self.cards = [
            WordCard(
                word: "Resilient",
                transcription: "[rɪˈzɪl.jənt]",
                translation: "Стойкий, жизнерадостный",
                exampleUsage: "Babies are generally remarkably resilient.",
                repetitionLevel: 2
            ),
            WordCard(
                word: "Ubiquitous",
                transcription: "[juːˈbɪk.wə.təs]",
                translation: "Вездесущий, повсеместный",
                exampleUsage: "Smartphones have become ubiquitous in daily life.",
                repetitionLevel: 4
            ),
            WordCard(
                word: "Ephemeral",
                transcription: "[ɪˈfem.ər.əl]",
                translation: "Эфемерный, недолговечный",
                exampleUsage: "Fame in the digital age is often ephemeral.",
                repetitionLevel: 1
            )
        ]
    }
}
