import SwiftUI
import SwiftData

public struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = AddWordViewModel()

    public var defaultDeck: DeckEntity?

    public init(defaultDeck: DeckEntity? = nil) {
        self.defaultDeck = defaultDeck
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Оптический захват")) {
                    Button(action: {
                        viewModel.isScannerPresented = true
                    }) {
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .font(.title3)
                                .foregroundColor(.blue)
                            Text("Сканировать слово камерой")
                                .fontWeight(.medium)
                        }
                    }
                }

                Section(header: Text("Детали карточки")) {
                    TextField("Иностранное слово", text: $viewModel.recognizedWord)
                        .onChange(of: viewModel.recognizedWord) { _, newValue in
                            viewModel.lookupInRealmDictionary(word: newValue)
                        }

                    if viewModel.isAutofilledFromRealm {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                            Text("Автозаполнено из словаря Realm")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                    }

                    TextField("Транскрипция", text: $viewModel.transcription)
                    TextField("Перевод", text: $viewModel.translation)
                    TextField("Пример использования", text: $viewModel.exampleUsage)
                }

                if let deck = defaultDeck {
                    Section(header: Text("Целевая колода (SwiftData)")) {
                        HStack {
                            Image(systemName: deck.iconName)
                                .foregroundColor(.blue)
                            Text(deck.title)
                        }
                    }
                }
            }
            .navigationTitle("Новое слово")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        if viewModel.saveCard(to: defaultDeck, in: modelContext) {
                            dismiss()
                        }
                    }
                    .disabled(viewModel.recognizedWord.isEmpty || viewModel.translation.isEmpty)
                }
            }
            .sheet(isPresented: $viewModel.isScannerPresented) {
                TextScannerView { text in
                    viewModel.handleCapturedText(text)
                }
            }
        }
    }
}
