//  FederatedTimelineQuery.swift
//  Created by Konstantin on 09/03/2023.

import Foundation

/// Specifies the parameters for a federated timeline request
public struct FederatedTimelineQuery: Codable, Sendable {
    public init(onlyMedia: Bool? = nil) {
        self.onlyMedia = onlyMedia
    }
    
    public static func globalTimeLineQuery() -> Self {
        var query = Self()
        query.remote = true
        return query
    }

    /// Return only posts with media attachments
    public var onlyMedia: Bool?
    
    /// Use global feed. Pixelfed only.
    public var remote: Bool?
}

extension FederatedTimelineQuery: TimelineQuery {

    public func getQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        if let onlyMedia {
            queryItems.append(.init(name: "only_media", value: String(onlyMedia)))
        }
        
        if let remote {
            queryItems.append(.init(name: "remote", value: String(remote)))
        }

        return queryItems
    }

}
