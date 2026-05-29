import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthState
    @EnvironmentObject var navigation: NavigationState

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Profile")
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)

                    VStack(alignment: .leading, spacing: Spacing.md) {
                        row(label: "Name", value: auth.currentUser?.name ?? "—")
                        row(label: "Email", value: auth.currentUser?.email ?? "—")
                    }
                    .padding(Spacing.cardPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.surface)
                    .cornerRadius(Spacing.radiusLarge)

                    AscendButton("Sign Out", variant: .destructive, size: .large, fullWidth: true) {
                        auth.signOut()
                        navigation.goHome()
                    }
                }
                .padding(Spacing.screenPadding)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func row(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
        }
    }
}
