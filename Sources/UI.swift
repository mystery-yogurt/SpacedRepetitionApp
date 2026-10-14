import SwiftUI
import SwiftData
import Charts
import VisionKit

class HomeViewModel: ObservableObject {
    @Published var chartData: [(day: String, count: Int)] = [("Пн", 12), ("Вт", 25), ("Ср", 18), ("Чт", 30)]
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Chart(viewModel.chartData, id: \.day) { data in
                        BarMark(x: .value("Day", data.day), y: .value("Count", data.count))
                            .foregroundStyle(.blue.gradient)
                    }.frame(height: 150).padding()
                    
                    Button("Начать сессию (\(words.filter { $0.nextReviewDate <= Date() }.count))") {
                        showSession = true
                    }
                    .buttonStyle(.borderedProminent).controlSize(.large)
                    
                    ForEach(words) { word in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(word.word).font(.headline)
                                Text("Повтор: \(word.nextReviewDate.formatted(date: .abbreviated, time: .omitted))").font(.caption)
                            }
                            Spacer()
                            Text(word.translation)
                        }.padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
                    }.padding(.horizontal)
                }
            }
            .navigationTitle("Тренажер")
            .sheet(isPresented: $showSession) {
                if let word = words.filter({ $0.nextReviewDate <= Date() }).first {
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
