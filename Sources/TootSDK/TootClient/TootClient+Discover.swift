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
 
 
 GetAccountsByUsername
 api/v1.1/accounts/username/${username}?_pe=1
 
 GetHashtagByName
 https://${instance}/api/v1/tags/${queryKey[1]}/?_pe=1
 
 GetHashtagByName Feed
 https://${instance}/api/v1/timelines/tag/${id}?_pe=1&max_id=${page}
 
 GetRelatedTags
 https://${instance}/api/v1/tags/${id}/related
 
 GetComposeSettings
 api/v1.1/compose/settings
 
 GetConfig
 https://${instance}/api/v2/config
 
 GetOpenServers
 'https://pixelfed.org/api/v1/mobile-app/servers/open.json',
     {
       method: 'get',
       headers: new Headers({
         Accept: 'application/json',
         'X-Pixelfed-App': '1',
         'Content-Type': 'application/json',
       }),
     }
 Array of:
 interface OpenServer {
   domain: string
   header_thumbnail: string
   mobile_registration: boolean
   version: string
   short_description: string
   user_count: number
   last_seen_at: string
 }
 
 GetSelfCollections
 `https://${instance}/api/v1.1/collections/self?page=${pageParam}`
 
 GetAppSettings
 https://${instance}/api/pixelfed/v1/app/settings
 
 FetchChatThread
 `api/v1.1/direct/thread?pid=${id}`
 
 DeleteChatMessage
 `api/v1.1/direct/thread/message?id=${id}`
 
 export async function sendChatMessage(id: string, message: string) {
   const path = `api/v1.1/direct/thread/send`
   return await selfPost(path, {
     to_id: id,
     message: message,
     type: 'text',
   })
 }
 
 GetAdminStats
 `api/admin/stats`
 
 GetAdminConfig
 'api/admin/config'
 
 export async function updateAdminConfig(params) {
   return await selfPost('api/admin/config/update', params)
 }
 
 export async function getAdminUsers(cursor) {
   let url
   const instance = Storage.getString('app.instance')
   url = cursor != null ? cursor : `https://${instance}/api/admin/users/list?sort=desc`
   return await fetchCursorPagination(url)
 }

 export async function getAdminUser(id: string) {
   return await selfGet(`api/admin/users/get?user_id=${id}`)
 }
 
 export async function getModReports() {
   return await selfGet('api/admin/mod-reports/list')
 }

 export async function getAutospamReports() {
   return await selfGet('api/admin/autospam/list')
 }

 export async function postUserHandle(params) {
   return await selfPost('api/admin/users/action', params)
 }

 export async function postReportHandle(params) {
   return await selfPost('api/admin/mod-reports/handle', params)
 }
 
 export async function postAutospamHandle(params) {
   return await selfPost('api/admin/autospam/handle', params)
 }
 
 
 
 export async function adminInstances(queryKey?: { pageParam?: string }, sort, sortBy) {
   const instance = Storage.getString('app.instance')
   let path = queryKey?.pageParam
     ? queryKey.pageParam
     : `https://${instance}/api/admin/instances/list?order_by=sort=${sort}&sort_by=${sortBy}`
   const res = await fetchData(path)
   return { data: res.data, nextPage: res.links?.next, prevPage: res.links?.prev }
 }
 
 AdminInstanceGet
 'api/admin/instances/get'
 
 GetTrendingPosts
 'api/v1.1/discover/posts/network/trending'
 
 export async function getMutualFollowing({ queryKey }) {
   return await selfGet(`api/v1.1/accounts/mutuals/${queryKey[1]}`)
 }
 
 
 export async function getStoryCarousel() {
   return await selfGet(`api/v1.1/stories/carousel`)
 }

 export async function pushNotificationSupported() {
   return await selfGet(`api/v1.1/nag/state`)
 }

 export async function pushState() {
   return await selfGet(`api/v1.1/push/state`, false, false, true)
 }

 export async function pushStateDisable() {
   return await selfPost(`api/v1.1/push/disable`, false, false, false, true)
 }

 export async function pushStateCompare(params) {
   return await selfPost(`api/v1.1/push/compare`, params, false, false, false, true)
 }

 export async function pushStateUpdate(params) {
   return await selfPost(`api/v1.1/push/update`, params, false, false, false, true)
 }
 
 {{baseUrl}}/api/v2/comments/{{accountId}}/status/{{postId}}
 {
   "data": [
     {
       "_v": 1,
       "id": "579468102489198615",
       "shortcode": "gKrytHidAX",
       "uri": "https://holopics.imperialba.se/p/zolotkey/579468102489198615",
       "url": "https://holopics.imperialba.se/p/zolotkey/579468102489198615",
       "in_reply_to_id": "579451430018162710",
       "in_reply_to_account_id": null,
       "reblog": null,
       "content": "So pretty. Apple sure makes a great phone/Camera.",
       "content_text": "So pretty. Apple sure makes a great phone/Camera.",
       "created_at": "2023-06-28T00:39:21.000Z",
       "emojis": [],
       "reblogs_count": 0,
       "favourites_count": 0,
       "reblogged": null,
       "favourited": null,
       "muted": null,
       "sensitive": false,
       "spoiler_text": "",
       "visibility": "public",
       "application": {
         "name": "web",
         "website": null
       },
       "language": null,
       "mentions": [],
       "pf_type": "text",
       "reply_count": 0,
       "comments_disabled": false,
       "thread": false,
       "replies": [],
       "parent": [],
       "place": null,
       "local": true,
       "taggedPeople": [],
       "label": {
         "covid": false
       },
       "liked_by": {
         "id": "574319997687160836",
         "username": "joshhrach",
         "url": "/i/web/profile/574319997687160836",
         "others": false,
         "total_count": -1,
         "total_count_pretty": "-1"
       },
       "media_attachments": [],
       "account": {
         "id": "574310139110768641",
         "username": "zolotkey",
         "acct": "zolotkey",
         "display_name": "Nick Zolotko",
         "discoverable": true,
         "locked": false,
         "followers_count": 4,
         "following_count": 6,
         "statuses_count": 81,
         "note": "Nerd, Husband/Father, {Star Wars, <a href=\"https://holopics.imperialba.se/discover/tags/Apple?src=hash\" title=\"#Apple\" class=\"u-url hashtag\" rel=\"external nofollow noopener\">#Apple</a>, <a href=\"https://holopics.imperialba.se/discover/tags/FreeBSD?src=hash\" title=\"#FreeBSD\" class=\"u-url hashtag\" rel=\"external nofollow noopener\">#FreeBSD</a>, Cleveland <a href=\"https://holopics.imperialba.se/discover/tags/Browns?src=hash\" title=\"#Browns\" class=\"u-url hashtag\" rel=\"external nofollow noopener\">#Browns</a>} Fan",
         "note_text": "Nerd, Husband/Father, {Star Wars, #Apple, #FreeBSD, Cleveland #Browns} Fan",
         "url": "https://holopics.imperialba.se/zolotkey",
         "avatar": "https://holopics.imperialba.se/storage/avatars/057/431/013/911/076/864/1/x3VDxmtnBWjZDXH8KdFI_avatar.jpg?v=2",
         "website": null,
         "local": true,
         "is_admin": true,
         "created_at": "2023-06-13T19:03:27.000000Z",
         "header_bg": null,
         "last_fetched_at": null,
         "pronouns": [],
         "location": null
       },
       "tags": [],
       "poll": null,
       "edited_at": null
     }
   ],
   "meta": {
     "pagination": {
       "total": 1,
       "count": 1,
       "per_page": 10,
       "current_page": 1,
       "total_pages": 1,
       "links": {}
     }
   }
 }
 
 CreateReply: "post" {{baseUrl}}/api/v1/statuses
 status:string
 in_reply_to_id: string
 
 */
