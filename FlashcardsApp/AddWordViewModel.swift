import Foundation
import SwiftData

@MainActor
public final class AddWordViewModel: ObservableObject {
    @Published public var recognizedWord: String = ""
    @Published public var transcription: String = ""
    @Published public var translation: String = ""
    @Published public var exampleUsage: String = ""
    @Published public var isScannerPresented: Bool = false
    @Published public var isAutofilledFromRealm: Bool = false

    public init() {}

    /// Обработка захваченного слова с автопоиском в Realm
    public func handleCapturedText(_ text: String) {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
        self.recognizedWord = cleaned
        lookupInRealmDictionary(word: cleaned)
    }

    /// Поиск слова в нереляционном офлайн-хранилище Realm
    public func lookupInRealmDictionary(word: String) {
        if let match = RealmDictionaryService.shared.lookup(word: word) {
            self.transcription = match.transcription
            self.translation = match.translation
            self.exampleUsage = match.exampleUsage
            self.isAutofilledFromRealm = true
        } else {
            self.isAutofilledFromRealm = false
        }
    }

    /// Сохранение карточки в реляционную БД SwiftData
    public func saveCard(to deck: DeckEntity?, in context: ModelContext) -> Bool {
        guard !recognizedWord.isEmpty, !translation.isEmpty else { return false }

        let newCard = CardEntity(
            word: recognizedWord,
            transcription: transcription.isEmpty ? "[-]" : transcription,
            translation: translation,
            exampleUsage: exampleUsage.isEmpty ? "No example provided." : exampleUsage,
            repetitionLevel: 0,
            easinessFactor: 2.5,
            intervalDays: 0,
            repetitions: 0,
            nextDueDate: Date(),
            deck: deck
        )

        context.insert(newCard)
        try? context.save()
        return true
    }
}
