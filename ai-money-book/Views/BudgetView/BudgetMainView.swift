import SwiftUI

struct BudgetMainView: View {
    @State private var selectedMonth = "8월"
    @State private var monthlyExpense = 527189
    @State private var monthlyIncome = 527189
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 헤더 (항상 고정)
                HStack {
                    // 왼쪽: 가계부 텍스트
                    HStack {
                        Text("가계부")
                            .font(.title2)
                            .fontWeight(.heavy)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 가운데: 월 선택
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        
                        Text(selectedMonth)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 오른쪽: 검색 버튼
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color(UIColor.systemBackground))
                
                // 스크롤 뷰 with sticky header
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            // 첫 번째 섹션: 수입/지출 요약
                            Section {
                                // 수입/지출 요약
                                VStack(spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("지출")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text("\(monthlyExpense.formatted()) 원")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(AppColors.primary)
                                        }
                                        
                                        Spacer()
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 1, height: 30)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("수입")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text("\(monthlyIncome.formatted()) 원")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke((AppColors.borderGray), lineWidth: 1)
                                    )
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                            }
                            
                            // 두 번째 섹션: 거래 내역 (sticky header와 함께)
                            Section {
                                LazyVStack(spacing: 20) {
                                    // ✅ 섹션 1: 1일 금요일
                                    SectionCard(title: "1일 금요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720),
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "이마트", category: "식비", amount: 13894)
                                    ])
                                    
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                    // ✅ 섹션 2: 31일 목요일
                                    SectionCard(title: "31일 목요일", items: [
                                        Transaction(icon: "heart.fill", iconColor: .orange, title: "스타벅스", category: "카페/간식", amount: 5720)
                                    ])
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            } header: {
                                // Sticky header
                                ZStack {
                                    HStack {
                                        Button(action: {}) {
                                            HStack(spacing: 4) {
                                                Text("전체 내역")
                                                    .font(.caption)
                                                Image(systemName: "chevron.down")
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.gray.opacity(0.08))
                                            .cornerRadius(16)
                                            .foregroundColor(.black)
                                        }
                                        
                                        Spacer()
                                        
//                                        Button(action: {}) {
//                                            Image(systemName: "magnifyingglass")
//                                                .foregroundColor(.gray)
//                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 15)
                                    .background(Color(UIColor.systemBackground))
                                    
                                    // 플로팅 + 버튼 (오른쪽에 걸치게)
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            // 추가 액션
                                        }) {
                                            Image(systemName: "plus")
                                                .font(.title2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 56, height: 56)
                                        .background(Color.orange)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                        .offset(y: 15) // 아래로 살짝 내려서 걸치게
                                    }
                                    .padding(.trailing, 20)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
        }
    }
}


// 미리보기
struct BudgetMainView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetMainView()
    }
}
