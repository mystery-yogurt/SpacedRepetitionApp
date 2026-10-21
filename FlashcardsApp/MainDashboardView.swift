import SwiftUI

public struct MainDashboardView: View {
    @State private var decks: [Deck] = [
        Deck(title: "General English", description: "Повседневная лексика", totalCards: 120, dueCards: 15, iconName: "book.fill"),
        Deck(title: "IT & Software", description: "Термины разработки и архитектуры", totalCards: 85, dueCards: 8, iconName: "chevron.left.forwardslash.chevron.right"),
        Deck(title: "Travel & Airport", description: "Для путешествий и поездок", totalCards: 45, dueCards: 0, iconName: "airplane")
    ]

    @State private var weeklyStats: [DailyProgress] = [
        DailyProgress(dayOfWeek: "Пн", wordsLearned: 12, date: Date()),
        DailyProgress(dayOfWeek: "Вт", wordsLearned: 18, date: Date()),
        DailyProgress(dayOfWeek: "Ср", wordsLearned: 8, date: Date()),
        DailyProgress(dayOfWeek: "Чт", wordsLearned: 25, date: Date()),
        DailyProgress(dayOfWeek: "Пт", wordsLearned: 14, date: Date()),
        DailyProgress(dayOfWeek: "Сб", wordsLearned: 30, date: Date()),
        DailyProgress(dayOfWeek: "Вс", wordsLearned: 22, date: Date())
    ]

    @State private var isStudySessionActive = false
    @State private var isAddWordActive = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Swift Charts статистика
                    WeeklyStatsChartView(stats: weeklyStats)
                        .padding(.horizontal)

                    // Запуск сессии интервального повторения
                    Button(action: {
                        isStudySessionActive = true
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.title3)
                            Text("Начать сессию повторений")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: .blue.opacity(0.3), radius: 6, y: 4)
                    }
                    .padding(.horizontal)

                    // Список словарей
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Мои словари")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)

                        LazyVStack(spacing: 8) {
                            ForEach(decks) { deck in
                                DeckRowView(deck: deck)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("SM-2 Карточки")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddWordActive = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .fullScreenCover(isPresented: $isStudySessionActive) {
                StudySessionView()
            }
            .sheet(isPresented: $isAddWordActive) {
                AddWordView { newCard in
                    // Обновляем счетчик для демо-режима
                    if let firstIndex = decks.indices.first {
                        let current = decks[firstIndex]
                        decks[firstIndex] = Deck(
                            title: current.title,
                            description: current.description,
                            totalCards: current.totalCards + 1,
                            dueCards: current.dueCards + 1,
                            iconName: current.iconName
                        )
                    }
                }
            }
        }
    }
}
