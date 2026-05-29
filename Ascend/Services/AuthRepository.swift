import Foundation
import GRPCCore

@available(iOS 18.0, *)
struct AuthRepository {
    static let shared = AuthRepository()
    private let clientManager = GRPCClientManager.shared

    func register(email: String, password: String, name: String) async throws -> (token: String, user: CurrentUser) {
        return try await clientManager.withClient { grpcClient in
            let client = Auth_AuthService.Client(wrapping: grpcClient)
            let response = try await client.register(.with {
                $0.email = email
                $0.password = password
                $0.name = name
            })
            return (response.token, currentUser(from: response.user))
        }
    }

    func login(email: String, password: String) async throws -> (token: String, user: CurrentUser) {
        return try await clientManager.withClient { grpcClient in
            let client = Auth_AuthService.Client(wrapping: grpcClient)
            let response = try await client.login(.with {
                $0.email = email
                $0.password = password
            })
            return (response.token, currentUser(from: response.user))
        }
    }

    func me() async throws -> CurrentUser {
        return try await clientManager.withClient { grpcClient in
            let client = Auth_AuthService.Client(wrapping: grpcClient)
            let user = try await client.me(Auth_MeRequest())
            return currentUser(from: user)
        }
    }

    private func currentUser(from proto: Auth_User) -> CurrentUser {
        CurrentUser(id: proto.id, email: proto.email, name: proto.name)
    }
}
