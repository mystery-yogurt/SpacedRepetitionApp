import SwiftUI
import SwiftData

public struct RealmDictionaryBrowserView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var searchText: String = ""
    @State private var searchResults: [DictionaryWordItem] = []
    @State private var selectedWordToImport: DictionaryWordItem?
    @State private var isImportAlertPresented: Bool = false

    public var targetDeck: DeckEntity?

    public init(targetDeck: DeckEntity? = nil) {
        self.targetDeck = targetDeck
    }

    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Всего в офлайн-базе: \(searchResults.count) слов")) {
                    ForEach(searchResults) { word in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(word.word)
                                    .font(.headline)
                                Text(word.transcription)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("#\(word.frequencyRank)")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.purple.opacity(0.15))
                                    .foregroundColor(.purple)
                                    .cornerRadius(6)
                            }
                            Text(word.translation)
                                .font(.subheadline)
                                .foregroundColor(.green)

                            Text(word.exampleUsage)
                                .font(.caption)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedWordToImport = word
                            isImportAlertPresented = true
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Поиск по 1000 словам в Realm")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .onAppear {
                performSearch(query: searchText)
            }
            .navigationTitle("Словарь Realm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
            .alert("Добавить в словарь?", isPresented: $isImportAlertPresented) {
                Button("Добавить в SwiftData") {
                    if let word = selectedWordToImport {
                        importToSwiftData(word: word)
                    }
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                if let word = selectedWordToImport {
                    Text("Импортировать «\(word.word)» в вашу личную колоду?")
                }
            }
        }
    }

    private func performSearch(query: String) {
        self.searchResults = RealmDictionaryService.shared.search(query: query)
    }

    private func importToSwiftData(word: DictionaryWordItem) {
        let card = CardEntity(
            word: word.word,
            transcription: word.transcription,
            translation: word.translation,
            exampleUsage: word.exampleUsage,
            repetitionLevel: 0,
            deck: targetDeck
        )
        modelContext.insert(card)
        try? modelContext.save()
    }
}
