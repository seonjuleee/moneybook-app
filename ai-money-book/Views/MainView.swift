import SwiftUI
import CoreData
import Foundation

// MARK: - Main View (지출 입력 및 리스트)
struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var inputText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.createdAt, ascending: false)],
        animation: .default)
    private var expenses: FetchedResults<Expense>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 지출 입력 섹션
                VStack(alignment: .leading, spacing: 12) {
                    Text("지출 내역 입력")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        TextField("예: 6월 24일 스타벅스에서 6,000원 썼어", text: $inputText, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3)
                            .padding(.horizontal)
                        
                        Button(action: addExpense) {
                            Text("등록")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .disabled(inputText.isEmpty)
                    }
                }
                .padding(.vertical)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // 최근 지출 리스트
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("최근 지출 내역")
                            .font(.headline)
                        Spacer()
                        Text("총 \(expenses.count)건")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    if expenses.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("아직 지출 내역이 없습니다")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        List {
                            ForEach(expenses, id: \.id) { expense in
                                ExpenseRowView(expense: expense)
                                    .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteExpenses)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("가계부")
            .alert("알림", isPresented: $showingAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addExpense() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "지출 내역을 입력해주세요."
            showingAlert = true
            return
        }
        
        let analysis = ExpenseAnalyzer.shared.analyzeExpense(inputText)
        
        guard analysis.amount > 0 else {
            alertMessage = "금액을 정확히 입력해주세요."
            showingAlert = true
            return
        }
        
        let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.date = analysis.date
        newExpense.amount = analysis.amount
        newExpense.item = analysis.item
        newExpense.category = analysis.category
        newExpense.originalText = inputText
        newExpense.createdAt = Date()
        
        do {
            try viewContext.save()
            inputText = ""
            alertMessage = "지출 내역이 등록되었습니다!"
            showingAlert = true
        } catch {
            alertMessage = "저장 중 오류가 발생했습니다."
            showingAlert = true
        }
    }
    
    private func deleteExpenses(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

#Preview {
    MainView() // 미리 보고 싶은 뷰
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
