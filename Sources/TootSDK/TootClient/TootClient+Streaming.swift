//
//  TootClient+Streaming.swift
//
//
//  Created by Dale Price on 5/23/24.
//

import Foundation

/// Encapsulates a WebSocket connection to a server for streaming timeline updates.
public class TootSocket {
    /// The underlying WebSocket task.
    public let webSocketTask: URLSessionWebSocketTask
    private let encoder = TootEncoder()
    private let decoder = TootDecoder()
    
    /// Async throwing stream of all ``StreamingEvent``s sent by the server.
    public lazy var stream: AsyncThrowingStream<StreamingEvent, Error> = {
        AsyncThrowingStream<StreamingEvent, Error> { [weak webSocketTask, weak decoder] in
            guard let webSocketTask else { return nil }
            
            let message = try await webSocketTask.receive()
            let data = switch message {
            case .data(let data):
                data
            case .string(let string):
                string.data(using: .utf8)
            @unknown default:
                throw TootSDKError.decodingError("message")
            }
            guard let data else { throw TootSDKError.decodingError("message data") }
            
            guard let decoder else { return nil }
            return try decoder.decode(StreamingEvent.self, from: data)
        }
    }()
    
    /// Send a JSON-encoded request to subscribe to or unsubscribe from a streaming timeline.
    ///
    /// - Parameter query: The request to subscribe or unsubscribe to a particular streaming timeline.
    /// - Throws: Any thrown errors from `TootEncoder/encode()` or `URLSessionWebSocketTask/send()`.
    ///
    /// - SeeAlso: [Mastodon API: WebSocket query parameters](https://docs.joinmastodon.org/methods/streaming/#parameters)
    public func sendQuery(_ query: StreamQuery) async throws {
        let encodedQuery = try encoder.encode(query)
        // In theory we can just send the encoded Data over the websocket. In practice, Mastodon has an undocumented requirement to only send strings or it will immediately terminate the connection. So we have to recast the data we just encoded to a string.
        guard let encodedString = String(data: encodedQuery, encoding: .utf8) else {
            throw TootSDKError.internalError("Unable to read UTF-8 string from encoded JSON.")
        }
        try await webSocketTask.send(.string(encodedString))
    }
    
    internal init(webSocketTask: URLSessionWebSocketTask) {
        self.webSocketTask = webSocketTask
        self.webSocketTask.resume()
    }
    
    deinit {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
}

extension TootClient {
    /// Opens a WebSocket connection to the server's streaming API, if it is available and alive.
    ///
    /// - Returns: If the server provides a streaming API via ``TootClient/getInstanceInfo()`` and it is alive according to ``TootClient/getStreamingHealth()``, returns a ``TootSocket`` instance representing the connection.
    /// - Throws: ``TootSDKError/streamingUnsupported`` if the server does not provide a valid URL for the streaming endpoint. ``TootSDKError/streamingEndpointUnhealthy`` if the server does not affirm that the streaming API is alive.
    public func beginStreaming() async throws -> TootSocket {
        // TODO: make sure instance flavor supports streaming
        
        // get streaming endpoint URL from instance info
        async let streamingEndpoint = getInstanceInfo().urls?.streamingApi
        async let streamingHealthy = getStreamingHealth()
        
        guard let streamingEndpoint = try await streamingEndpoint,
              let streamingURL = URL(string: streamingEndpoint) else {
            throw TootSDKError.streamingUnsupported
        }
        guard try await streamingHealthy else {
            throw TootSDKError.streamingEndpointUnhealthy
        }
        
        let task = webSocketTask(streamingAPI: streamingURL)
        
        return TootSocket(webSocketTask: task)
    }
    
    /// Check whether the streaming endpoint is alive.
    ///
    /// - Returns: `true` if the server returns HTTP status code `200`, indicating that the streaming endpoint is alive.
    public func getStreamingHealth() async throws -> Bool {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "streaming", "health"])
            $0.method = .get
        }
        let (_, response) = try await fetch(req: req)
        return response.statusCode == 200
    }
    
    /// Creates a web socket task with the given query items, and the access token if the client is authenticated.
    ///
    /// - Parameters:
    ///   - streamingAPI: The URL of the streaming API.
    /// - Returns: The result of calling the client's `session.webSocketTask(with:protocols:)` with the given query items and the access token if available.
    internal func webSocketTask(streamingAPI: URL) -> URLSessionWebSocketTask {
        let path = ["api", "v1", "streaming"]
        var url = streamingAPI
        for component in path {
            url.appendPathComponent(component)
        }
        
        if let accessToken {
            // It's undocumented, but the Mastodon streaming API passes the access token using the `protocols` field.
            return session.webSocketTask(with: url, protocols: [accessToken])
        } else {
            return session.webSocketTask(with: url)
        }
    }
}
