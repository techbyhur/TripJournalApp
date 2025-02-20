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
    
    enum CodingKeys: String, CodingKey {
        case locLat = "latitude"
        case locLong = "longitude"
        case locAddress = "address"
    }
    
    init(latitude: Double, longitude: Double, address: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try values.decode(Double.self, forKey: .locLat)
        self.longitude = try values.decode(Double.self, forKey: .locLong)
        self.address = try values.decodeIfPresent(String.self, forKey: .locAddress)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .locLat)
        try container.encode(longitude, forKey: .locLong)
        try container.encode(address, forKey: .locAddress)
    }
}
