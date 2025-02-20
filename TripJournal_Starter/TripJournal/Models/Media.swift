//
//  Media.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import Foundation
import SwiftData

/// Represents a media with a URL.
@Model
final class Media: Identifiable, Sendable, Hashable, Codable {
    
    @Attribute(.unique)
    var id: Int
    
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case mediaId = "id"
        case mediaUrl = "url"
    }
    
    init(url: URL? = nil) {
        self.id = Int.random(in: 0...10000)
        self.url = url
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .mediaId)
        self.url = try values.decodeIfPresent(URL.self, forKey: .mediaUrl)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .mediaId)
        try container.encodeIfPresent(url, forKey: .mediaUrl)
    }
}
