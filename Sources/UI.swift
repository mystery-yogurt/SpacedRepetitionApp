import SwiftUI
import SwiftData
import Charts

struct DailyStat: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

class HomeViewModel: ObservableObject {
    @Published var chartData: [DailyStat] = [
        DailyStat(day: "Пн", count: 12),
        DailyStat(day: "Вт", count: 25),
        DailyStat(day: "Ср", count: 18),
        DailyStat(day: "Чт", count: 30)
    ]
}

class FlashcardViewModel: ObservableObject {
    @Published var isFlipped = false
    func flip() { withAnimation { isFlipped.toggle() } }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserWord.nextReviewDate) private var words: [UserWord]
    @StateObject private var viewModel = HomeViewModel()
    @State private var showSession = false

    var nextWord: UserWord? {
        let now = Date()
        return words.first { $0.nextReviewDate <= now }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Chart(viewModel.chartData) { data in
                        BarMark(x: .value("Day", data.day), y: .value("Count", data.count))
                            .foregroundStyle(.blue.gradient)
                    }
                    .frame(height: 150)
                    .padding()
                    
                    Button("Начать сессию") {
                        showSession = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    ForEach(words) { word in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(word.word).font(.headline)
                                Text("Повтор: \(word.nextReviewDate.formatted(date: .abbreviated, time: .omitted))").font(.caption)
                            }
                            Spacer()
                            Text(word.translation)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Тренажер")
            .sheet(isPresented: $showSession) {
                if let word = nextWord {
                    FlashcardView(word: word)
                } else {
                    Text("Всё повторено!")
                }
            }
        }
    }
}

struct FlashcardView: View {
    let word: UserWord
    @StateObject private var viewModel = FlashcardViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Text(word.word).font(.largeTitle)
                    .opacity(viewModel.isFlipped ? 0 : 1)
                
                Text(word.translation).font(.largeTitle).foregroundColor(.blue)
                    .opacity(viewModel.isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            .frame(width: 300, height: 400)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .rotation3DEffect(.degrees(viewModel.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .onTapGesture { viewModel.flip() }
            
            if viewModel.isFlipped {
                HStack {
                    Button("Забыл") { answer(0) }
                    Button("Нормально") { answer(3) }
                    Button("Легко") { answer(5) }
                }.padding()
            }
        }
    }
    
    private func answer(_ quality: Int) {
        SM2Algorithm.reviewWord(word: word, quality: quality)
        dismiss()
    }
}
