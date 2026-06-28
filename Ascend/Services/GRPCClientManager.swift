import GRPCCore
import GRPCNIOTransportHTTP2

@available(iOS 18.0, *)
struct AuthInterceptor: ClientInterceptor {
    func intercept<Input: Sendable, Output: Sendable>(
        request: StreamingClientRequest<Input>,
        context: ClientContext,
        next: @Sendable (StreamingClientRequest<Input>, ClientContext) async throws -> StreamingClientResponse<Output>
    ) async throws -> StreamingClientResponse<Output> {
        var request = request
        if let token = await AuthState.shared.token {
            request.metadata.addString("Bearer \(token)", forKey: "authorization")
        }
        return try await next(request, context)
    }
}

@available(iOS 18.0, *)
final class GRPCClientManager: Sendable {
    static let shared = GRPCClientManager()

    private let host = "ascend-backend-barsbold.fly.dev"
    private let port = 50051

    func withClient<Result: Sendable>(
        _ operation: (GRPCClient<HTTP2ClientTransport.Posix>) async throws -> Result
    ) async throws -> Result {
        let transport = try HTTP2ClientTransport.Posix(
            target: .dns(host: host, port: port),
            transportSecurity: .plaintext
        )
        return try await withGRPCClient(
            transport: transport,
            interceptors: [AuthInterceptor()]
        ) { client in
            try await operation(client)
        }
    }
}
