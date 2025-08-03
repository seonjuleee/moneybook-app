import SwiftUI

// MARK: - Simple Pie Chart View
struct PieChartView: View {
    let data: [CategoryData]
    
    private var total: Double {
        data.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        ZStack {
            if data.isEmpty {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            } else {
                ForEach(Array(data.enumerated()), id: \.element.category) { index, categoryData in
                    PieSliceView(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: categoryColor(categoryData.category)
                    )
                }
            }
            
            // 중앙 원
            Circle()
                .fill(Color(.systemBackground))
                .frame(width: 100, height: 100)
            
            VStack {
                Text("총합")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(Int(total))원")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previousTotal = data.prefix(index).reduce(0) { $0 + $1.amount }
        return Angle(degrees: (previousTotal / total) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let currentTotal = data.prefix(index + 1).reduce(0) { $0 + $1.amount }
        return Angle(degrees: (currentTotal / total) * 360 - 90)
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "식비": return .orange
        case "교통비": return .blue
        case "쇼핑": return .pink
        case "의료비": return .red
        case "문화생활": return .purple
        default: return .gray
        }
    }
}

#Preview {
    let mockData = [
        CategoryData(category: "식비", amount: 12000, count: 3),
        CategoryData(category: "교통비", amount: 8000, count: 3),
        CategoryData(category: "쇼핑", amount: 15000, count: 3),
        CategoryData(category: "문화생활", amount: 5000, count: 3)
    ]
    
    PieChartView(data: mockData)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
