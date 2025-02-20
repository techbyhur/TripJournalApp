//
//  Location.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import SwiftData
import Foundation
import MapKit

/// Represents a location.
@Model
final class Location: Sendable, Hashable, Codable {
    var latitude: Double
    var longitude: Double
    var address: String?

    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    init(from decoder: any Decoder) throws {
#warning("Update with accurate decoding logic")
        self.latitude = 0.0
        self.longitude = 0.0
        self.address = nil
    }
    
    func encode(to encoder: any Encoder) throws {
#warning("Encode to JSON Object")
    }
}
