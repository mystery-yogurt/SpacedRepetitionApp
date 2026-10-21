import Foundation

// Модель личного словаря
struct Deck: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let totalCards: Int
    let dueCards: Int
    let iconName: String
}

// Модель для графика Swift Charts (дни недели)
struct DailyProgress: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let wordsLearned: Int
    let date: Date
}
