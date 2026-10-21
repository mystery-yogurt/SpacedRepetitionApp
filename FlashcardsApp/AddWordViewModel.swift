import Foundation

public final class AddWordViewModel: ObservableObject {
    @Published public var recognizedWord: String = ""
    @Published public var transcription: String = ""
    @Published public var translation: String = ""
    @Published public var exampleUsage: String = ""
    @Published public var isScannerPresented: Bool = false

    public init() {}

    public func handleCapturedText(_ text: String) {
        // Очищаем слово от лишних знаков препинания
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
        self.recognizedWord = cleaned

        // Базовые автозаполнения для демонстрации архитектуры (в ЛР4 подключится Combine-брокер)
        if cleaned.lowercased() == "serendipity" {
            self.transcription = "[ˌser.ənˈdɪp.ə.ti]"
            self.translation = "Счастливая случайность, интуитивная прозорливость"
            self.exampleUsage = "Finding this book was pure serendipity."
        }
    }

    public func buildNewCard() -> WordCard? {
        guard !recognizedWord.isEmpty, !translation.isEmpty else { return nil }
        return WordCard(
            word: recognizedWord,
            transcription: transcription.isEmpty ? "[-]" : transcription,
            translation: translation,
            exampleUsage: exampleUsage.isEmpty ? "No example provided." : exampleUsage,
            repetitionLevel: 0
        )
    }
}
