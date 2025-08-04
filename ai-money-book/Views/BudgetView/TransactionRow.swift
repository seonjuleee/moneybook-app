import SwiftUI

struct TransactionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let category: String
    let amount: Int
    let isExpense: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // 아이콘
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 16))
            }
            
            // 제목과 카테고리
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                Text(category)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 금액
            Text("\(amount.formatted()) 원")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isExpense ? .black : .blue)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
