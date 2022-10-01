//
//  YouTubeResult.swift
//  WMovie
//
//  Created by Алексей Павленко on 01.10.2022.
//

import Foundation

struct YoutubeIdElement: Decodable {
    let kind: String
    let videoId: String
}

struct YoutubeResult: Decodable, CustomStringConvertible {
    let id: YoutubeIdElement
    
    var description: String {
        return "YoutubeResult(id(kind: \(id.kind), videoId: \(id.videoId)"
    }
}

/*
 {
   "kind": "youtube#searchListResponse",
   "etag": "DCV78Dg0u8HD9Js8guoRzx005r8",
   "nextPageToken": "CAUQAA",
   "regionCode": "UA",
   "pageInfo": {
     "totalResults": 1000000,
     "resultsPerPage": 5
   },
   "items": [
     {
       "kind": "youtube#searchResult",
       "etag": "N8qiJX-rznpbC1JGlcU4qeITJ2U",
       "id": {
         "kind": "youtube#video",
         "videoId": "ZyppV2tfIAw"
       }
     },
     {
 */
