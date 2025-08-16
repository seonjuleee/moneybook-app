import SwiftUI

public struct CategoryBadge: View {
    public enum SelectedStyle { case solid, outline, soft }
    
    let title: String
    let color: Color
    let systemName: String?   // SF Symbol (예: "bag" 또는 "bag.fill")
    let emoji: String?        // 이모지 쓰고 싶으면 여기로 (예: "😀")
    let isSelected: Bool
    let selectedStyle: SelectedStyle
    let minWidth: CGFloat
    let corner: CGFloat
    
    public init(
        title: String,
        color: Color,
        systemName: String? = nil,
        emoji: String? = nil,
        isSelected: Bool,
        selectedStyle: SelectedStyle = .solid,
        minWidth: CGFloat = 92,
        corner: CGFloat = 14
    ) {
        self.title = title
        self.color = color
        self.systemName = systemName
        self.emoji = emoji
        self.isSelected = isSelected
        self.selectedStyle = selectedStyle
        self.minWidth = minWidth
        self.corner = corner
    }
    
    // 선택/비선택 상태에 따른 색/테두리/그림자
    private var background: Color {
        guard isSelected else { return Color.gray.opacity(0.18) }
        switch selectedStyle {
        case .solid:   return color
        case .outline: return .white
        case .soft:    return color.opacity(0.12)
        }
    }
    private var foreground: Color {
        guard isSelected else { return Color.gray }
        switch selectedStyle {
        case .solid:   return .white
        case .outline: return color
        case .soft:    return color
        }
    }
    private var border: Color? {
        guard isSelected else { return nil }
        switch selectedStyle {
        case .outline: return color
        default:       return nil
        }
    }
    private var shadowOpacity: Double {
        (isSelected && selectedStyle == .solid) ? 0.15 : 0.0
    }
    
    private func displaySymbolName() -> String? {
        guard let name = systemName else { return nil }
        let isFill = name.hasSuffix(".fill")
        switch selectedStyle {
        case .solid:
            // solid일 땐 fill 버전을 쓰자
            return isFill ? name : name + ".fill"
        case .outline, .soft:
            // outline/soft일 땐 라인 버전을 쓰자
            return isFill ? String(name.dropLast(5)) : name
        }
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            if let e = emoji {
                Text(e).font(.system(size: 14))
            } else if let sym = displaySymbolName() {
                Image(systemName: sym)
                    .font(.system(size: 14, weight: .semibold))
            }
            Text(title)
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundColor(foreground)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .overlay {
            if let border { RoundedRectangle(cornerRadius: corner).stroke(border, lineWidth: 2) }
        }
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .shadow(color: Color.black.opacity(shadowOpacity), radius: 10, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

#Preview("Single – Variants (Light)") {
    VStack(alignment: .leading, spacing: 12) {
        CategoryBadge(title: "식비", color: .orange, systemName: "bag.fill", isSelected: true,  selectedStyle: .solid)
        CategoryBadge(title: "식비", color: .orange, systemName: "bag",      isSelected: true,  selectedStyle: .outline)
        CategoryBadge(title: "식비", color: .orange, emoji: "🙂",            isSelected: true,  selectedStyle: .soft)
        CategoryBadge(title: "식비", color: .gray,   systemName: "bag",      isSelected: false)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .previewLayout(.sizeThatFits)
}


// 4단 고정, 셀 간격 0인 그리드 프리뷰
private struct CategoryBadgePreviewGrid: View {
    let data: [(String, Color, String?, String?, Bool, CategoryBadge.SelectedStyle)] = [
        ("식비", .orange, "bag.fill", nil, true,  .solid),
        ("식비", .orange, "bag",      nil, true,  .outline),
        ("식비", .orange, nil,        "🙂", true,  .soft),
        ("식비", .gray,   "bag",      nil, false, .solid),
        ("식비", .gray,   "bag",      nil, false, .solid),
        ("식비", .gray,   "bag",      nil, false, .solid),
        ("식비", .gray,   "bag",      nil, false, .solid),
        ("식비", .gray,   "bag",      nil, false, .solid)
    ]
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<data.count, id: \.self) { i in
                let d = data[i]
                CategoryBadge(
                    title: d.0,
                    color: d.1,
                    systemName: d.2,
                    emoji: d.3,
                    isSelected: d.4,
                    selectedStyle: d.5,
                    minWidth: 0 // 4단 셀 폭에 꼭 맞추기
                )
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
