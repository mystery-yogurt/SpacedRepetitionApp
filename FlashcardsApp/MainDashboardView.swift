import SwiftUI
import SwiftData

public struct MainDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DeckEntity.createdAt, order: .forward) private var decks: [DeckEntity]
    @Query(sort: \DailyProgressEntity.date, order: .forward) private var weeklyStats: [DailyProgressEntity]

    @State private var isStudySessionActive = false
    @State private var isAddWordActive = false
    @State private var isRealmDictionaryActive = false

    @StateObject private var realmService = RealmDictionaryService.shared

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Статистика за неделю
                    WeeklyStatsChartView(
                        stats: weeklyStats.map {
                            DailyProgress(dayOfWeek: $0.dayOfWeek, wordsLearned: $0.wordsLearned, date: $0.date)
                        }
                    )
                    .padding(.horizontal)

                    // Кнопка запуска тренировки
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

                    // Баннер Realm
                    Button(action: {
                        isRealmDictionaryActive = true
                    }) {
                        HStack(spacing: 14) {
                            Image(systemName: "books.vertical.fill")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .frame(width: 44, height: 44)
                                .background(Color.purple.opacity(0.15))
                                .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Базовый офлайн-словарь (Realm)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text(realmService.wordsCount > 0 ? "\(realmService.wordsCount) слов" : "Загрузка...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)

                    // Список словарей SwiftData
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Мои словари (SwiftData)")
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("Колод: \(decks.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)

                        LazyVStack(spacing: 8) {
                            ForEach(decks) { deckEntity in
                                DeckRowView(
                                    deck: Deck(
                                        title: deckEntity.title,
                                        description: deckEntity.deckDescription,
                                        totalCards: deckEntity.cards.count,
                                        dueCards: deckEntity.dueCardsCount,
                                        iconName: deckEntity.iconName
                                    )
                                )
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
            .task {
                DataSeeder.seedInitialDataIfNeeded(context: modelContext)
                realmService.initializeDictionaryIfNeeded()
            }
            .fullScreenCover(isPresented: $isStudySessionActive) {
                StudySessionView()
            }
            .sheet(isPresented: $isAddWordActive) {
                AddWordView(defaultDeck: decks.first)
            }
            .sheet(isPresented: $isRealmDictionaryActive) {
                RealmDictionaryBrowserView(targetDeck: decks.first)
            }
        }
    }
}
