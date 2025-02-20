//
//  Event.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import SwiftData
import Foundation

@Model
final class Event: Identifiable, Sendable, Hashable, Codable, Comparable {
    
    @Attribute(.unique)
    var id: UUID
    var name: String
    var note: String?
    var date: Date
    
    @Relationship(deleteRule: .cascade)
    var location: Location?
    
    @Relationship(deleteRule: .cascade)
    var medias: [Media]
    
    var transitionFromPrevious: String?
    
    init(id: UUID, name: String, note: String? = nil, date: Date, location: Location? = nil, medias: [Media], transitionFromPrevious: String? = nil) {
        self.id = id
        self.name = name
        self.note = note
        self.date = date
        self.location = location
        self.medias = medias
        self.transitionFromPrevious = transitionFromPrevious
    }
    
    init(from decoder: any Decoder) throws {
        #warning("Update with accurate decoding logic")
        self.id = UUID()
        self.name = ""
        self.note = nil
        self.date = Date()
        self.location = nil
        self.medias = []
        self.transitionFromPrevious = nil
    }
    
    func encode(to encoder: any Encoder) throws {
        #warning("Encode to JSON Object")
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
}
