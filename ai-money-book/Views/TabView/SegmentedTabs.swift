import SwiftUI

struct SegmentedTabs: View {
    let titles: [String]
    @Binding var selection: Int

    // 색/치수 토큰
    private let containerBG = Color(.systemGray6)
    private let selectedBG  = Color.white
    private let selectedFG  = Color.black
    private let normalFG    = Color.gray
    private let radius: CGFloat = 18
    private let vPad: CGFloat = 8
    private let hPad: CGFloat = 12

    // 버튼 프레임 전달용 PreferenceKey
    private struct TabFrameKey: PreferenceKey {
        static var defaultValue: [Int: Anchor<CGRect>] = [:]
        static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }

    var body: some View {
        ZStack {
            // 바탕 캡슐
            RoundedRectangle(cornerRadius: radius)
                .fill(containerBG)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.03), radius: 8, y: 2)

            // 탭 버튼들
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { i in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                            selection = i
                        }
                    } label: {
                        Text(titles[i])
                            .font(.system(size: 14, weight: selection == i ? .semibold : .medium))
                            .foregroundColor(selection == i ? selectedFG : normalFG)
                            .padding(.horizontal, hPad)
                            .padding(.vertical, vPad)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .background( // 각 버튼의 프레임을 부모에 전달
                        GeometryReader { proxy in
                            Color.clear.anchorPreference(key: TabFrameKey.self, value: .bounds) { [i: $0] }
                        }
                    )

                    // 가운데 구분선
                    if i < titles.count - 1 {
                        Rectangle()
                            .fill(Color.black.opacity(0.12))
                            .frame(width: 1, height: 16)
                            .allowsHitTesting(false)
                    }
                }
            }
            .padding(4)
            // ⬇️ 하이라이트를 "버튼 뒤"에 그린다 (텍스트를 덮지 않음)
            .backgroundPreferenceValue(TabFrameKey.self) { frames in
                GeometryReader { proxy in
                    if let anchor = frames[selection] {
                        let rect = proxy[anchor]
                        RoundedRectangle(cornerRadius: radius - 6)
                            .fill(selectedBG)
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            .animation(.spring(response: 0.28, dampingFraction: 0.9), value: selection)
                    }
                }
            }
        }
        .frame(height: 40)
        .padding(.horizontal)
    }
}
