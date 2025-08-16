import SwiftUI

/// 0 = 지출, 1 = 수입
struct IncomeExpensePillToggle: View {
    @Binding var selection: Int
    var expenseColor: Color = .orange
    var incomeColor: Color  = .gray.opacity(0.25)

    var body: some View {
        ZStack {
            // 수입 pill (뒤쪽)
            pill(title: "지출",
                 isSelected: selection == 0,
                 bg: selection == 0 ? expenseColor : .gray.opacity(0.15)) {
                selection = 0
            }
            .offset(x: -20, y: -6) // 왼쪽 위로 살짝 이동
            .zIndex(selection == 0 ? 1 : 0)

            // 지출 pill (앞쪽)
            pill(title: "수입",
                 isSelected: selection == 1,
                 bg: selection == 1 ? .green : incomeColor) {
                selection = 1
            }
            .offset(x: 20, y: 6) // 오른쪽 아래로 살짝 이동
            .zIndex(selection == 1 ? 1 : 0)
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.9), value: selection)
    }

    @ViewBuilder
    private func pill(title: String, isSelected: Bool, bg: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .gray.opacity(0.7))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(bg)
                )
                .shadow(color: isSelected ? .black.opacity(0.18) : .clear,
                        radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StatefulPreviewWrapper(0) { $sel in
        IncomeExpensePillToggle(selection: $sel)
            .padding()
            .background(Color(.systemBackground))
    }
}

// 미리보기용 래퍼
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    let content: (Binding<Value>) -> Content
    init(_ initial: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initial); self.content = content
    }
    var body: some View { content($value) }
}
