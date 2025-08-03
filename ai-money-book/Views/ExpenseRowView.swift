import SwiftUI
import Foundation

// MARK: - Expense Row View
struct ExpenseRowView: View {
    let expense: Expense
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 카테고리 아이콘
            ZStack {
                Circle()
                    .fill(categoryColor(expense.category ?? ""))
                    .frame(width: 44, height: 44)
                
                Image(systemName: categoryIcon(expense.category ?? ""))
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.item ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Text(dateFormatter.string(from: expense.date ?? Date()))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(expense.category ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("-\(Int(expense.amount))원")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
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
    
    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "식비": return "fork.knife"
        case "교통비": return "car.fill"
        case "쇼핑": return "bag.fill"
        case "의료비": return "cross.fill"
        case "문화생활": return "tv.fill"
        default: return "questionmark"
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sampleExpense = Expense(context: context)
    sampleExpense.id = UUID()
    sampleExpense.item = "스타벅스"
    sampleExpense.category = "식비"
    sampleExpense.amount = 6500
    sampleExpense.date = Date()
    sampleExpense.createdAt = Date()
    
    return ExpenseRowView(expense: sampleExpense)
        .environment(\.managedObjectContext, context)
}
