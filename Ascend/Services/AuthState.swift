import Foundation

struct CurrentUser: Equatable {
    let id: String
    let email: String
    let name: String
}

@MainActor
final class AuthState: ObservableObject {
    static let shared = AuthState()

    @Published private(set) var token: String?
    @Published private(set) var currentUser: CurrentUser?

    private let tokenKey = "session-token"

    init() {
        self.token = Keychain.get(tokenKey)
    }

    var isSignedIn: Bool { token != nil }

    func setAuthenticated(token: String, user: CurrentUser) {
        Keychain.set(token, for: tokenKey)
        self.token = token
        self.currentUser = user
    }

    func setUser(_ user: CurrentUser) {
        self.currentUser = user
    }

    func signOut() {
        Keychain.remove(tokenKey)
        self.token = nil
        self.currentUser = nil
    }
}
