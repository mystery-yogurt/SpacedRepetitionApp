import SwiftUI

struct StudySessionView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Сессия интервального повторения")
                    .font(.title2)
                    .bold()

                Text("В Лабораторной работе №2 здесь будет реализована интерактивная двусторонняя флэш-карточка слова.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
                Spacer()

                Button("Завершить досрочно") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.bottom, 24)
            }
            .navigationTitle("Тренировка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
}
