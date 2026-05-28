import GRPCCore
import GRPCNIOTransportHTTP2

@available(iOS 18.0, *)
final class GRPCClientManager: Sendable {
    static let shared = GRPCClientManager()

    private let host = "localhost"
    private let port = 8888

    func withClient<Result: Sendable>(
        _ operation: (GRPCClient<HTTP2ClientTransport.Posix>) async throws -> Result
    ) async throws -> Result {
        let transport = try HTTP2ClientTransport.Posix(
            target: .dns(host: host, port: port),
            transportSecurity: .plaintext
        )
        return try await withGRPCClient(transport: transport) { client in
            try await operation(client)
        }
    }
}
