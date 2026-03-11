import SwiftUI

struct ProgressRing<Content: View>: View {
    let progress: Double;
    let lineWidth: CGFloat
    let size: CGFloat
    let trackColor: Color
    let ringColor: Color
    @ViewBuilder let content: () -> Content

    init(
        progress: Double,
        lineWidth: CGFloat = 12,
        size: CGFloat = 80,
        trackColor: Color = Color.surface,
        ringColor: Color = Color.primary,
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.trackColor = trackColor
        self.ringColor = ringColor
        self.content = content
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            content()
        }
        .frame(width: size, height: size)
    }
}
