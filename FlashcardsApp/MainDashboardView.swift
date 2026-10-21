import SwiftUI

struct MainDashboardView: View {
    // Демо-данные для ЛР1 (в ЛР3 будут заменены на SwiftData)
    @State private var decks: [Deck] = [
        Deck(title: "General English", description: "Повседневная лексика", totalCards: 120, dueCards: 15, iconName: "book.fill"),
        Deck(title: "IT & Software", description: "Термины разработки и архитектуры", totalCards: 85, dueCards: 8, iconName: "chevron.left.forwardslash.chevron.right"),
        Deck(title: "Travel & Airport", description: "Для путешествий и поездок", totalCards: 45, dueCards: 0, iconName: "airplane")
    ]

    // Статистика за последние 7 дней (Swift Charts)
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. График статистики (Swift Charts)
                    WeeklyStatsChartView(stats: weeklyStats)
                        .padding(.horizontal)

                    // 2. Кнопка "Запуск сессии повторений"
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

                    // 3. Каталог личных словарей
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
            .fullScreenCover(isPresented: $isStudySessionActive) {
                StudySessionView()
            }
        }
    }
}
