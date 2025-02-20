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
    var id: Int
    var name: String
    var note: String?
    var date: Date
    
    @Relationship(deleteRule: .cascade)
    var location: Location?
    
    @Relationship(deleteRule: .cascade)
    var medias: [Media]
    
    var transitionFromPrevious: String?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "id"
        case eventName = "name"
        case eventNote = "note"
        case eventDate = "date"
        case eventLocation = "location"
        case eventMedias = "medias"
        case eventTransition = "transition_from_previous"
    }
    
    init(name: String, note: String? = nil, date: Date, location: Location? = nil, medias: [Media], transitionFromPrevious: String? = nil) {
        self.id = Int.random(in: 0...10000)
        self.name = name
        self.note = note
        self.date = date
        self.location = location
        self.medias = medias
        self.transitionFromPrevious = transitionFromPrevious
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .eventId)
        self.name = try values.decode(String.self, forKey: .eventName)
        self.note = try values.decodeIfPresent(String.self, forKey: .eventNote)
        self.date = try values.decode(Date.self, forKey: .eventDate)
        self.location = try values.decodeIfPresent(Location.self, forKey: .eventLocation)
        self.medias = try values.decode([Media].self, forKey: .eventMedias)
        self.transitionFromPrevious = try values.decodeIfPresent(String.self, forKey: .eventTransition)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .eventId)
        try container.encode(name, forKey: .eventName)
        try container.encodeIfPresent(note, forKey: .eventNote)
        try container.encode(date, forKey: .eventDate)
        try container.encodeIfPresent(location, forKey: .eventLocation)
        try container.encode(medias, forKey: .eventMedias)
        try container.encodeIfPresent(transitionFromPrevious, forKey: .eventTransition)
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
}
