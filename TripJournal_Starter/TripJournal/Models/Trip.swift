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
    var id: UUID
    
    var name: String
    var startDate: Date
    var endDate: Date
    
    @Relationship(deleteRule: .cascade)
    var events: [Event]
    
    init(id: UUID, name: String, startDate: Date, endDate: Date, events: [Event]) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.events = events
    }
    
    init(from decoder: any Decoder) throws {
#warning("Update with accurate decoding logic")
        id = UUID()
        name = ""
        startDate = Date()
        endDate = Date()
        events = []
    }
    
    func encode(to encoder: any Encoder) throws {
#warning("Encode to JSON Object")
    }
    
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
