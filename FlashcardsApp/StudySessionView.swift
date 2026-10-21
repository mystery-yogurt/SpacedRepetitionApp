import SwiftUI

public struct StudySessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = StudySessionViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isCompleted {
                    completionView
                } else if let card = viewModel.currentCard {
                    // Индикатор прогресса
                    Text(viewModel.progressText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    Spacer()

                    // Двусторонняя флэш-карточка
                    FlashcardView(card: card, isFlipped: $viewModel.isCardFlipped)

                    Spacer()

                    // Кнопки оценки уровня запоминания (активны после переворота)
                    if viewModel.isCardFlipped {
                        VStack(spacing: 8) {
                            Text("Оцените, насколько хорошо вы помните слово:")
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
            .navigationTitle("Тренировка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Выход") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Сессия завершена!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Все запланированные слова успешно повторены.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button("Вернуться в меню") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        }
        .padding()
    }
}
