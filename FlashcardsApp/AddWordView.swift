import SwiftUI

public struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddWordViewModel()
    public let onCardCreated: (WordCard) -> Void

    public init(onCardCreated: @escaping (WordCard) -> Void) {
        self.onCardCreated = onCardCreated
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
                    TextField("Транскрипция", text: $viewModel.transcription)
                    TextField("Перевод", text: $viewModel.translation)
                    TextField("Пример использования", text: $viewModel.exampleUsage)
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
                        if let newCard = viewModel.buildNewCard() {
                            onCardCreated(newCard)
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
