//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import Combine
import Foundation

class LiveJournalService: JournalService {
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    @Published private var token: Token?
    
    func register(username: String, password: String) async throws -> Token {
        <#code#>
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        <#code#>
    }
    
    func logOut() {
        <#code#>
    }
    
    func createTrip(with request: TripCreate) async throws -> Trip {
        <#code#>
    }
    
    func getTrips() async throws -> [Trip] {
        <#code#>
    }
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        <#code#>
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        <#code#>
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        <#code#>
    }
    
    func createEvent(with request: EventCreate) async throws -> Event {
        <#code#>
    }
    
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        <#code#>
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        <#code#>
    }
    
    func createMedia(with request: MediaCreate) async throws -> Media {
        <#code#>
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        <#code#>
    }
    
    func fetchTrips() async throws -> [Trip] {
        return []
    }
}
