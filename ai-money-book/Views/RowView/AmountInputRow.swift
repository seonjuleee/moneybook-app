import SwiftUI

// 왼쪽 수입/지출 토글 + 중앙 금액 입력 + 오른쪽 '원' + 밑줄
// selection: 0 = 지출, 1 = 수입
public struct AmountInputRow: View {
    @Binding private var selection: Int
    @Binding private var amount: String

    private let underlineLeftInset: CGFloat
    private let hSpacing: CGFloat

    // 천단위 포맷터
    private static let groupingFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","          // 로케일 기본 쓰려면 주석 처리 가능
        f.usesGroupingSeparator = true
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 0
        return f
    }()

    public init(
        selection: Binding<Int>,
        amount: Binding<String>,
        underlineLeftInset: CGFloat = 100,
        hSpacing: CGFloat = 12
    ) {
        self._selection = selection
        self._amount = amount
        self.underlineLeftInset = underlineLeftInset
        self.hSpacing = hSpacing
    }

    public var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .center, spacing: hSpacing) {
                // 이전에 분리했던 토글 사용
                IncomeExpensePillToggle(selection: $selection)

                ZStack(alignment: .leading) {
                    if amount.isEmpty {
                        Text("금액")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 18, weight: .regular))
                    }
                    TextField("", text: $amount)
                        .keyboardType(.numberPad)
                        .font(.system(size: 18, weight: .medium))
                        .monospacedDigit()
                        .onChange(of: amount) { newValue in
                            // 숫자만 남기고 천단위로 재포맷
                            let digits = newValue.filter(\.isNumber)
                            if digits.isEmpty {
                                if !newValue.isEmpty { amount = "" } // 모두 지우면 빈 값 유지
                                return
                            }
                            let num = NSDecimalNumber(string: digits)
                            if num == .notANumber { return }
                            let formatted = AmountInputRow.groupingFormatter.string(from: num) ?? digits
                            if formatted != newValue {
                                amount = formatted   // 커서는 끝으로 이동 (numberPad에선 OK)
                            }
                        }
                }
                .padding(.leading, 40)

                Spacer(minLength: 8)

                Text("원")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }

            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 1)
                .padding(.leading, underlineLeftInset)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct StatefulPreviewWrapper2<A,B,Content: View>: View {
    @State var a: A; @State var b: B
    let content: (Binding<A>, Binding<B>) -> Content
    init(_ a: A, _ b: B, content: @escaping (Binding<A>, Binding<B>) -> Content) {
        _a = State(initialValue: a); _b = State(initialValue: b); self.content = content
    }
    var body: some View { content($a, $b) }
}

#Preview {
    StatefulPreviewWrapper2(0, "") { $sel, $amt in
        AmountInputRow(selection: $sel, amount: $amt)
            .padding()
            .background(Color(.systemBackground))
    }
}
