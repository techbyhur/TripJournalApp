//
//  OfflineCacheManager.swift
//  TripJournal
//
//  Created by Ila Hur on 2/20/25.
//

import Foundation

class OfflineCacheManager {
    private let userDefaults = UserDefaults.standard
    private let tripsKey = "trips"

    func saveTrips(_ trips: [Trip]) {
        do {
            let data = try JSONEncoder().encode(trips)
            userDefaults.set(data, forKey: tripsKey)
        } catch {
            print("Failed to save trips: \(error)")
        }
    }

    func loadTrips() -> [Trip] {
        guard let data = userDefaults.data(forKey: tripsKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Trip].self, from: data)
        } catch {
            print("Failed to load trips: \(error)")
            return []
        }
    }
}
