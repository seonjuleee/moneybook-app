import SwiftUI

struct TransactionRowView: View {
    let item: Transaction
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(item.iconColor.opacity(0.2)) // 연한 원형 배경
                    .frame(width: 36, height: 36)
                Image(systemName: item.icon)
                    .foregroundColor(item.iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(item.amount.formatted()) 원")
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

struct Transaction {
    let icon: String
    let iconColor: Color
    let title: String
    let category: String
    let amount: Int
}

struct TransactionRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRowView(item: Transaction(
            icon: "heart.fill",
            iconColor: .blue,
            title: "스타벅스",
            category: "카페/간식",
            amount: 5720
        ))
        .previewLayout(.sizeThatFits) // ✅ 미리보기 크기 지정
        .padding()
    }
}
