import SwiftUI

struct AddBudgetInputs: View {
    @State private var selectedDate = Date()
    @State private var memo = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // 날짜
            LabeledInputRow(label: "날짜") {
                Text(selectedDate.formatted(date: .long, time: .shortened))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // 내용
            LabeledInputRow(label: "내용") {
                TextField("", text: $memo)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.top, 8)
    }
}
