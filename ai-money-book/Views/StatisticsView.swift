// StatisticsView.swift 파일 상단에 추가
import SwiftUI
import CoreData

// MARK: - Category Data Model
struct CategoryData {
    let category: String
    let amount: Double
    let count: Int
}

// MARK: - Statistics View
struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)],
        animation: .default)
    private var allExpenses: FetchedResults<Expense>
    
    private var currentMonthExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date()
        return allExpenses.filter { expense in
            calendar.isDate(expense.date ?? now, equalTo: now, toGranularity: .month)
        }
    }
    
    private var totalAmount: Double {
        currentMonthExpenses.reduce(0) { $0 + $1.amount }
    }
    
    private var categoryData: [CategoryData] {
        let groupedExpenses = Dictionary(grouping: currentMonthExpenses) { $0.category }
        return groupedExpenses.map { category, expenses in
            let total = expenses.reduce(0) { $0 + $1.amount }
            return CategoryData(category: category ?? "", amount: total, count: expenses.count)
        }.sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 이번 달 총 지출
                    VStack(spacing: 12) {
                        Text("이번 달 총 지출")
                            .font(.headline)
                        
                        Text("\(Int(totalAmount))원")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("\(currentMonthExpenses.count)건의 지출")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // 카테고리별 통계
                    if !categoryData.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("카테고리별 지출")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            // 파이 차트 영역
                            PieChartView(data: categoryData)
                                .frame(height: 300)
                                .padding(.horizontal)
                            
                            // 카테고리 목록
                            LazyVStack(spacing: 12) {
                                ForEach(categoryData, id: \.category) { data in
                                    CategoryRowView(data: data, total: totalAmount)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.pie")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("이번 달 지출 내역이 없습니다")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("통계")
        }
    }
}

#Preview {
    StatisticsView() // 미리 보고 싶은 뷰
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
