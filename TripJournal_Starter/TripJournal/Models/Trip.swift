//
//  Trip.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import SwiftData
import Foundation
import MapKit

/// Represents a trip.
@Model
final class Trip: Identifiable, Sendable, Hashable, Codable, Comparable {
    
    @Attribute(.unique)
    var id: Int
    
    var name: String
    var startDate: Date
    var endDate: Date
    
    @Relationship(deleteRule: .cascade)
    var events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case tripId = "id"
        case tripName = "name"
        case tripIdStartDate = "start_date"
        case tripIdEndDate = "end_date"
        case tripIdEvents = "events"
    }
    
    init(name: String, startDate: Date, endDate: Date, events: [Event]) {
        self.id = Int.random(in: 0...10000)
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.events = events
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .tripId)
        self.name = try values.decode(String.self, forKey: .tripName)
        self.startDate = try values.decode(Date.self, forKey: .tripIdStartDate)
        self.endDate = try values.decode(Date.self, forKey: .tripIdEndDate)
        self.events = try values.decode([Event].self, forKey: .tripIdEvents)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .tripId)
        try container.encode(name, forKey: .tripName)
        try container.encode(startDate, forKey: .tripIdStartDate)
        try container.encode(endDate, forKey: .tripIdEndDate)
        try container.encode(events, forKey: .tripIdEvents)
    }
    
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
