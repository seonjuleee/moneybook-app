// MARK: - 5. ContentView.swift (기존 파일 수정)
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("통계")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView() // 미리 보고 싶은 뷰
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
