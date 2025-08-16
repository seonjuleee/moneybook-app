import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    var onDone: () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("오늘") { selectedDate = Date() }
                    .font(.system(size: 16))
                Spacer()
                Button("완료") {
                    onDone()
                }
                .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal)

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.wheel)   // 날짜+시간에 가장 자연스러운 휠 스타일
            .labelsHidden()
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)
        }
        .padding(.top, 12)
    }
}
