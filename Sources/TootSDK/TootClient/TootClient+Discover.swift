//
//  TootClient+Discover.swift
//  TootSDK
//
//  Created by Josh Hrach on 1/13/25.
//

import Foundation

extension TootClient {
    /*
     /// List accounts visible in the directory.
     ///
     /// - Parameters:
     ///   - offset. Skip the first n results.
     ///   - limit: How many accounts to load. Defaults to 40 accounts. Max 80 accounts.
     ///   - params: Includes order and local parameters.
     /// - Returns: Array of ``Account``.
     public func getProfileDirectory(params: ProfileDirectoryParams, offset: Int? = nil, limit: Int? = nil) async throws -> [Account] {
         try requireFeature(.profileDirectory)
         let req = HTTPRequestBuilder {
             $0.url = getURL(["api", "v1", "directory"])
             $0.method = .get
             $0.query = getQueryParams(limit: limit, offset: offset) + params.queryItems
         }

         return try await fetch([Account].self, req)
     }
     */
    public func getTrendingHashtags() async throws -> [Tag] {
        try requireFeature(.discover)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1.1", "discover", "posts", "hashtags"])
            $0.method = .get
        }
        
        return try await fetch([Tag].self, req)
    }
    
    
    public func getTrendingPopularAccounts() async throws -> [Account] {
        try requireFeature(.discover)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1.1", "discover", "accounts", "popular"])
            $0.method = .get
        }

        return try await fetch([Account].self, req)
    }
    
    
    public func getTrendingPopularPosts() async throws -> [Post] {
        try requireFeature(.discover)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1.1", "discover", "posts", "trending"])
            $0.method = .get
            $0.add(queryItem: .init(name: "range", value: "daily"))
        }
        
        return try await fetch([Post].self, req)
    }
    
    
    public func getTrendingPostsMonthly() async throws -> [Post] {
        try requireFeature(.discover)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1.1", "discover", "posts", "trending"])
            $0.method = .get
            $0.add(queryItem: .init(name: "range", value: "monthly"))
        }
        
        return try await fetch([Post].self, req)
    }
}

extension TootFeature {

    /// Ability to query profile directories
    ///
    public static let discover = TootFeature(supportedFlavours: [.pixelfed])
}


/*
 export async function getTrendingHashtags() {
   const instance = Storage.getString('app.instance')
   let url = `https://${instance}/api/v1.1/discover/posts/hashtags`
   return await fetchData(url)
 }

 export async function getTrendingPopularAccounts() {
   const instance = Storage.getString('app.instance')
   let url = `https://${instance}/api/v1.1/discover/accounts/popular`
   return await fetchData(url)
 }

 export async function getTrendingPopularPosts() {
   const instance = Storage.getString('app.instance')
   let url = `https://${instance}/api/v1.1/discover/posts/trending?range=daily`
   return await fetchData(url)
 }

 export async function getTrendingPopularPostsMonthly() {
   const instance = Storage.getString('app.instance')
   let url = `https://${instance}/api/v1.1/discover/posts/trending?range=monthly`
   return await fetchData(url)
 }

 export async function getTrendingPopularPostsYearly() {
   const instance = Storage.getString('app.instance')
   let url = `https://${instance}/api/v1.1/discover/posts/trending?range=yearly`
   return await fetchData(url)
 */
