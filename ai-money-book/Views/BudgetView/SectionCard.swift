import SwiftUI

struct SectionCard: View {
    let title: String
    let items: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                ForEach(items, id: \.title) { item in
                    TransactionRowView(item: item)
                }
            }
            .padding()
            .background(Color(hex: "#FFF8F5")) // ✅ 카드 배경색
            .cornerRadius(20) // ✅ 라운드 처리
        }
    }
}
