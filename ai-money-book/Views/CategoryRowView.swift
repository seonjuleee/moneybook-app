import SwiftUI

// MARK: - Category Row View
struct CategoryRowView: View {
    let data: CategoryData
    let total: Double
    
    private var percentage: Double {
        total > 0 ? (data.amount / total) * 100 : 0
    }
    
    var body: some View {
        HStack {
            // 카테고리 색상 인디케이터
            Circle()
                .fill(categoryColor(data.category))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(data.category)
                    .font(.headline)
                Text("\(data.count)건")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(data.amount))원")
                    .font(.headline)
                Text("\(Int(percentage))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
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
    // Mock 데이터 생성
    let mockCategoryData = CategoryData(category: "식비", amount: 12000, count: 2)
    let mockTotal = 50000.0
    
    CategoryRowView(data: mockCategoryData, total: mockTotal)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
