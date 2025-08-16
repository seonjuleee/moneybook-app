import SwiftUI

/// 라벨(좌) + 입력/표시 박스(우) 공용 컴포넌트
public struct LabeledInputRow<Content: View>: View {
    private let label: String
    private let content: Content
    private let labelWidth: CGFloat
    private let bgColor: Color
    private let corner: CGFloat

    public init(
        label: String,
        labelWidth: CGFloat = 40,
        background: Color = Color.orange.opacity(0.06),
        cornerRadius: CGFloat = 14,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.labelWidth = labelWidth
        self.bgColor = background
        self.corner = cornerRadius
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: labelWidth, alignment: .leading)

            content
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        }
        .padding(.horizontal)
    }
}
