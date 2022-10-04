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
