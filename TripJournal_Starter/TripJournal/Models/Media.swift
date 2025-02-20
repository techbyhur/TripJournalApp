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
    var id: UUID
    var url: URL?
    
    init(id: UUID, url: URL? = nil) {
        self.id = id
        self.url = url
    }
    
    init(from decoder: any Decoder) throws {
#warning("Update with accurate decoding logic")
        self.id = UUID()
        self.url = nil
    }
    
    func encode(to encoder: any Encoder) throws {
        #warning("Encode to JSON Object")
    }
}
