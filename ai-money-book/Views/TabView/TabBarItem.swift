import SwiftUI

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .orange : .gray)
            
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .orange : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
