import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthState

    @State private var mode: Mode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var errorMessage: String? = nil
    @State private var loading = false

    enum Mode { case signIn, signUp }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Spacer()

                VStack(spacing: Spacing.xs) {
                    Text("Ascend")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    Text(mode == .signIn ? "Welcome back" : "Create your account")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }

                VStack(spacing: Spacing.md) {
                    if mode == .signUp {
                        textField("Name", text: $name, content: .name)
                    }
                    textField("Email", text: $email, content: .emailAddress, keyboard: .emailAddress)
                    secureField("Password", text: $password)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.labelSmall)
                        .foregroundColor(.error)
                        .multilineTextAlignment(.center)
                }

                AscendButton(
                    mode == .signIn ? "Sign In" : "Sign Up",
                    size: .large,
                    fullWidth: true
                ) {
                    Task { await submit() }
                }
                .disabled(loading)

                Button {
                    withAnimation {
                        mode = mode == .signIn ? .signUp : .signIn
                        errorMessage = nil
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(mode == .signIn ? "New here?" : "Already have an account?")
                            .foregroundColor(.textSecondary)
                        Text(mode == .signIn ? "Create an account" : "Sign in")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                    }
                    .font(.labelMedium)
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
    }

    private func textField(_ placeholder: String, text: Binding<String>, content: UITextContentType, keyboard: UIKeyboardType = .default) -> some View {
        TextField("", text: text, prompt: Text(placeholder).foregroundColor(.textSecondary))
            .textFieldStyle(.plain)
            .textContentType(content)
            .keyboardType(keyboard)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .foregroundColor(.textPrimary)
            .padding(Spacing.md)
            .background(Color.surface)
            .cornerRadius(Spacing.radiusMedium)
    }

    private func secureField(_ placeholder: String, text: Binding<String>) -> some View {
        SecureField("", text: text, prompt: Text(placeholder).foregroundColor(.textSecondary))
            .textContentType(mode == .signIn ? .password : .newPassword)
            .foregroundColor(.textPrimary)
            .padding(Spacing.md)
            .background(Color.surface)
            .cornerRadius(Spacing.radiusMedium)
    }

    private func submit() async {
        loading = true
        defer { loading = false }
        errorMessage = nil

        guard #available(iOS 18.0, *) else {
            errorMessage = "iOS 18+ required"
            return
        }

        do {
            let result: (token: String, user: CurrentUser)
            if mode == .signIn {
                result = try await AuthRepository.shared.login(email: email, password: password)
            } else {
                result = try await AuthRepository.shared.register(email: email, password: password, name: name)
            }
            auth.setAuthenticated(token: result.token, user: result.user)
        } catch {
            errorMessage = humanError(error)
        }
    }

    private func humanError(_ error: Error) -> String {
        let description = String(describing: error)
        if description.contains("invalid email or password") { return "Invalid email or password" }
        if description.contains("already registered") { return "Email is already registered" }
        if description.contains("at least 8") { return "Password must be at least 8 characters" }
        if description.contains("valid email") { return "Enter a valid email" }
        return "Something went wrong. Try again."
    }
}
