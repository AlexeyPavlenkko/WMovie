//
//  Movie.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

struct Movie: Decodable, CustomStringConvertible {
    let id: Int
    let title: String
    let year: Date
    let rate: Double?
    let mediaType: String?
    let posterImage: String?
    let backdropImage: String?
    let voteCount: Int?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case year = "release_date"
        case rate = "vote_average"
        case mediaType = "media_type"
        case posterImage = "poster_path"
        case backdropImage = "backdrop_path"
        case voteCount = "vote_count"
    }
    
    private enum AdditionalKeys: String, CodingKey {
        case name
        case first_air_date
    }
    
    init() {
        self.id = 0
        self.title = "Default title"
        self.year = Date()
        self.rate = nil
        self.mediaType = nil
        self.posterImage = nil
        self.backdropImage = nil
        self.voteCount = nil
        self.overview = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.overview = try? container.decodeIfPresent(String.self, forKey: .overview)
        self.rate = try? container.decodeIfPresent(Double.self, forKey: .rate)
        self.mediaType = try? container.decodeIfPresent(String.self, forKey: .mediaType)
        self.posterImage = try? container.decodeIfPresent(String.self, forKey: .posterImage)
        self.backdropImage = try? container.decodeIfPresent(String.self, forKey: .backdropImage)
        self.voteCount = try? container.decodeIfPresent(Int.self, forKey: .voteCount)
        
        let additionalContainer = try decoder.container(keyedBy: AdditionalKeys.self)
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        
        self.title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? (try? additionalContainer.decode(String.self, forKey: .name)) ?? "Unknown Title"
        self.year = (try? container.decodeIfPresent(Date.self, forKey: .year)) ?? (try? additionalContainer.decode(Date.self, forKey: .first_air_date)) ?? frmt.date(from: "01-01-9999")!
    }
    
    var description: String {
        "Movie(title: \(title), releaseDate: \(year), overview: \(overview ?? "don't have overview"), posteImagePath: \(posterImage ?? "-") "
    }
}

