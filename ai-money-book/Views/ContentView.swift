// MARK: - 5. ContentView.swift (기존 파일 수정)
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
  
    var body: some View {
        VStack(spacing: 0) {
            // 메인 컨텐츠
            Group {
                switch selectedTab {
                case 0:
                    BudgetMainView()
                case 1:
                    MainView()
                case 2:
                    StatisticsView()
                default:
                    BudgetMainView()
                }
            }
            
            // 커스텀 탭바
            HStack {
                Button(action: { selectedTab = 0 }) {
                    TabBarItem(icon: "chart.pie.fill", title: "가계부", isSelected: selectedTab == 0)
                }
                
                Button(action: { selectedTab = 1 }) {
                    TabBarItem(icon: "house.fill", title: "홈", isSelected: selectedTab == 1)
                }
                
                Button(action: { selectedTab = 2 }) {
                    TabBarItem(icon: "chart.bar.fill", title: "통계", isSelected: selectedTab == 2)
                }
            }
            .padding(.vertical, 8)
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
        }
    }
    
    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            BudgetMainView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("가계부")
//                }
//                .tag(0)
//            
//            MainView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("홈")
//                }
//                .tag(1)
//            
//            StatisticsView()
//                .tabItem {
//                    Image(systemName: "chart.pie.fill")
//                    Text("통계")
//                }
//                .tag(2)
//            
//        }
//    }
}

#Preview {
    ContentView() // 미리 보고 싶은 뷰
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
