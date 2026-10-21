import SwiftUI
import SwiftData

public struct StudySessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = StudySessionViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Загрузка очереди...")
                } else if viewModel.isCompleted || viewModel.cards.isEmpty {
                    completionView
                } else if let card = viewModel.currentCard {
                    HStack {
                        Text(viewModel.progressText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let entity = viewModel.currentCardEntity {
                            Spacer()
                            Text("EF: \(String(format: "%.2f", entity.easinessFactor)) | Дней: \(entity.intervalDays)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    Spacer()

                    FlashcardView(card: card, isFlipped: $viewModel.isCardFlipped)

                    Spacer()

                    if viewModel.isCardFlipped {
                        VStack(spacing: 8) {
                            Text("Оцените легкость ответа (SM-2):")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                Button("Забыл (1)") {
                                    viewModel.rateCurrentCard(rating: 1)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)

                                Button("Сложно (3)") {
                                    viewModel.rateCurrentCard(rating: 3)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)

                                Button("Легко (5)") {
                                    viewModel.rateCurrentCard(rating: 5)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.bottom, 20)
                    } else {
                        Text("Переверните карточку, чтобы выставить оценку")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 36)
                    }
                }
            }
            .navigationTitle("Интервальное повторение")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Выход") { dismiss() }
                }
            }
            .onAppear {
                viewModel.configure(with: modelContext)
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Очередь повторений чиста!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Все запланированные слова успешно повторены. SwiftData сохранила обновленные интервалы.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Вернуться в меню") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        }
        .padding()
    }
}
