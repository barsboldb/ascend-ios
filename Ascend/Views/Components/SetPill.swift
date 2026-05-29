import SwiftUI

struct SetPill: View {
    @Binding var sets: [SetLog]

    var body: some View {
        HStack {
            ForEach(Array(self.sets.enumerated()), id: \.element.id) { index, set in
                Group {
                    switch(set.status) {
                        case .pending:
                        SetIndicatorPending(index: index, set: set)
                        case .active:
                        SetIndicatorActive(index: index, set: set)
                        case .completed:
                        SetIndicatorCompleted(index: index, set: set)
                    }
                }
                .id(set.status)
                .transition(.scale.combined(with: .opacity))
            }
            if sets.count < 8 {
                Button {
                    guard sets.count <= 8 else { return }
                    self.sets.append(
                        SetLog(
                            id: UUID(),
                            targetWeight: 60.0,
                            targetRepRange: "6-8",
                            status: .pending,
                        )
                    )
                } label: {
                    Circle()
                        .fill(Color.background)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.labelSmall)
                                .foregroundColor(.textSecondary)
                        )
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusFull)
    }
}

struct SetIndicatorActive: View {
    let index: Int
    let set: SetLog

    var body: some View {
        Text("Set \(index + 1)")
            .font(.labelSmall)
            .foregroundColor(.textPrimary)
            .padding(.vertical, Spacing.sm)
            .padding(.horizontal, Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Spacing.radiusFull) 
                    .fill(Color.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: Spacing.radiusFull)
                            .stroke(Color.primary, style: StrokeStyle(lineWidth: 2))
                    )
            )
    }
}

struct SetIndicatorPending: View {
    let index: Int
    let set: SetLog

    var body: some View {
        Text("\(index + 1)")
            .font(.labelSmall)
            .foregroundColor(.textSecondary)
            .padding(Spacing.sm)
            .background(
                Circle() 
                    .fill(Color.background)
            )
    }
}

struct SetIndicatorCompleted: View {
    let index: Int
    let set: SetLog

    var body: some View {
        Image(systemName: "checkmark")
            .font(.labelSmall)
            .foregroundColor(.textPrimary)
            .padding(Spacing.sm)
            .background(
                Circle() 
                    .fill(Color.success)
            )
    }
}
