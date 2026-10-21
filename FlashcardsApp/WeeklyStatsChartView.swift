import SwiftUI
import Charts

struct WeeklyStatsChartView: View {
    let stats: [DailyProgress]

    private var chartStats: [DailyProgress] {
        if stats.isEmpty {
            let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
            return weekdays.map { DailyProgress(dayOfWeek: $0, wordsLearned: 0, date: Date()) }
        }
        return stats
    }

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

            Chart(chartStats) { item in
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
