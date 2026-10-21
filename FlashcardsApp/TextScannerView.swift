import SwiftUI
import VisionKit

public struct TextScannerView: UIViewControllerRepresentable {
    public let recognizedHandler: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    public init(recognizedHandler: @escaping (String) -> Void) {
        self.recognizedHandler = recognizedHandler
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            let scannerVC = DataScannerViewController(
                recognizedDataTypes: [.text(languages: ["en-US"])],
                qualityLevel: .balanced,
                recognizesMultipleItems: false,
                isHighFrameRateTrackingEnabled: false,
                isHighlightingEnabled: true
            )
            scannerVC.delegate = context.coordinator
            try? scannerVC.startScanning()
            return scannerVC
        } else {
            // Симулятор (где нет физической камеры) возвращает информационный экран
            let fallbackVC = UIHostingController(
                rootView: SimulatorCameraFallbackView { text in
                    recognizedHandler(text)
                    dismiss()
                }
            )
            return fallbackVC
        }
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: TextScannerView

        init(_ parent: TextScannerView) {
            self.parent = parent
        }

        public func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.recognizedHandler(text.transcript)
                parent.dismiss()
            default:
                break
            }
        }
    }
}

// Резервный экран для эмулятора
struct SimulatorCameraFallbackView: View {
    let onSimulate: (String) -> Void
    @State private var sampleWord: String = "serendipity"

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Симулятор оптического захвата")
                .font(.headline)

            Text("Камера не найдена (режим симулятора). Введите или выберите тестовое слово:")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            TextField("Иностранное слово", text: $sampleWord)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 40)
                .autocapitalization(.none)

            Button("Захватить слово") {
                onSimulate(sampleWord.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
