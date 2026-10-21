import SwiftUI

struct DeckRowView: View {
    let deck: Deck

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: deck.iconName)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(Color.blue.gradient)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(deck.title)
                    .font(.headline)
                Text(deck.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(deck.totalCards)")
                    .font(.subheadline)
                    .bold()
                if deck.dueCards > 0 {
                    Text("\(deck.dueCards) на повтор")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
