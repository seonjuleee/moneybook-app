import SwiftUI

struct CategoryItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let color: Color
    let systemName: String
}

struct AddBudgetView: View {
    @State private var selectedTab = 0 // 0: 직접 추가, 1: 영수증, 2: 결제 내역, 3: 문자
    @State private var transactionType = 0 // 0: 지출, 1: 수입
    @State private var amount = ""
    @State private var memo = ""
    @State private var selectedDate = Date()
    @State private var selectedCategoryIndex = 0
    @State private var showDatePicker = false
    @Environment(\.presentationMode) var presentationMode

    // 1) Identifiable 모델 사용 (중복 텍스트라도 OK)
    private let categories: [CategoryItem] = [
        .init(title: "식비", color: .orange, systemName: "cart.fill"),
        .init(title: "식비", color: .orange, systemName: "cart.fill"),
        .init(title: "식비", color: .yellow, systemName: "face.smiling"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill"),
        .init(title: "식비", color: .gray, systemName: "bag.fill")
    ]

    // 2) 컬럼을 미리 선언 (즉석 Array(repeating:) 지양)
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SegmentedTabs(
                    titles: ["직접 추가", "영수증", "결제 내역", "문자"],
                    selection: $selectedTab
                )

                ScrollView {
                    VStack(spacing: 20) {
                        // 수입/지출 토글
                        AmountInputRow(selection: $transactionType, amount: $amount)
                            .padding(.leading, 25)   // 왼쪽 살짝 띄우기
                            .padding(.trailing, 12) // 오른쪽 금액/원과의 간격
                            .padding(.top, 20)      // 위쪽과의 간격

                        // 날짜 (라벨 + 라운드 박스)
                        LabeledInputRow(label: "날짜") {
                            // 실제로는 DatePicker 연결해도 됨 (컴포넌트 분리 권장)
                            Button {
                                showDatePicker = true
                            } label: {
                                Text(selectedDate.formatted(date: .long, time: .shortened))
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .buttonStyle(.plain)
                        }
                        .sheet(isPresented: $showDatePicker) {
                            DatePickerSheet(selectedDate: $selectedDate) {
                                showDatePicker = false
                            }
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                        }
                        
                        LabeledInputRow(label: "내용") {
                            TextField("내용", text: $memo)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // 분류
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("분류")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black).frame(width: 40, alignment: .leading)
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)

                            // === 여백 설정값 ===
                            let outer: CGFloat   = 16   // 그리드 바깥 좌우 여백 (margin)
                            let hGutter: CGFloat = 8    // 가로 칸 사이 여백 (column gutter)
                            let vGutter: CGFloat = 8    // 세로 줄 사이 여백 (row gutter)

                            // 4열 고정 + 칸 사이 여백(hGutter)
                            let grid = Array(
                                repeating: GridItem(.flexible(), spacing: hGutter, alignment: .leading),
                                count: 4
                            )

                            LazyVGrid(columns: grid, alignment: .leading, spacing: vGutter) {
                                ForEach(categories.indices, id: \.self) { idx in
                                    let c = categories[idx]
                                    CategoryBadge(
                                        title: c.title,
                                        color: c.color,
                                        systemName: c.systemName,
                                        isSelected: idx == selectedCategoryIndex,
                                        selectedStyle: .solid
                                    )
                                    .onTapGesture { selectedCategoryIndex = idx }
                                    .frame(maxWidth: .infinity, alignment: .leading) // 각 셀 폭 가득 (필수)
                                    // (옵션) 셀 내부 위아래 여백 조금
                                    .padding(.vertical, 2)
                                }
                            }
                            // 바깥 좌우 여백(outer margin)
                            .padding(.horizontal, outer)

                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { presentationMode.wrappedValue.dismiss() } label: {
                        Image(systemName: "xmark").foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 저장 로직
                    } label: {
                        Text("저장")
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
}

struct AddBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetView()
    }
}
