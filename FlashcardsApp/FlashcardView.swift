import SwiftUI

public struct FlashcardView: View {
    public let card: WordCard
    @Binding public var isFlipped: Bool

    public init(card: WordCard, isFlipped: Binding<Bool>) {
        self.card = card
        self._isFlipped = isFlipped
    }

    public var body: some View {
        ZStack {
            // Лицевая сторона (Слово, транскрипция, уровень)
            frontCardView
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Оборотная сторона (Перевод, пример использования)
            backCardView
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .padding(.horizontal, 20)
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }

    // MARK: - Лицевая сторона
    private var frontCardView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Уровень знания: \(card.repetitionLevel)/5")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                Spacer()
                Image(systemName: "hand.tap")
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(card.word)
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(card.transcription)
                .font(.title3)
                .foregroundColor(.secondary)
                .italic()

            Spacer()

            Text("Нажмите, чтобы перевернуть")
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 5)
        )
    }

    // MARK: - Оборотная сторона
    private var backCardView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Перевод и контекст")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Spacer()
            }

            Spacer()

            Text(card.translation)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.green)

            Divider()
                .padding(.horizontal, 20)

            VStack(spacing: 6) {
                Text("Пример использования:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\"\(card.exampleUsage)\"")
                    .font(.body)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }

            Spacer()

            Text("Нажмите, чтобы скрыть ответ")
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 5)
        )
    }
}
