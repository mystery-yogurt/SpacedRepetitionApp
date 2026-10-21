import SwiftUI
import Charts

struct WeeklyStatsChartView: View {
    let stats: [DailyProgress]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.blue)
                Text("Статистика за неделю")
                    .font(.headline)
                Spacer()
                Text("Всего: \(stats.reduce(0) { $0 + $1.wordsLearned }) слов")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Chart(stats) { item in
                BarMark(
                    x: .value("День", item.dayOfWeek),
                    y: .value("Изучено слов", item.wordsLearned)
                )
                .foregroundStyle(Color.blue.gradient)
                .cornerRadius(6)
            }
            .frame(height: 140)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
