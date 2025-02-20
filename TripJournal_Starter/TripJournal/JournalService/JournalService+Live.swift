//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import Combine
import Foundation

class LiveJournalService: JournalService {
    
    var isTokenExpired: Bool = false
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    @Published private var token: Token? {
        didSet {
            if let token = token {
                try? KeychainHelper.shared.saveToken(token)
            } else {
                try? KeychainHelper.shared.deleteToken()
            }
        }
    }
    
    // Shared URLSession instance
    private let urlSession: URLSession
    
    //Network connection managers
    private let offlineCacheManager: OfflineCacheManager = OfflineCacheManager()
    @Published private var networkMonitor = NetworkMonitor()
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        self.urlSession = URLSession(configuration: configuration)

        if let savedToken = try? KeychainHelper.shared.getToken() {
            if !isTokenExpired(savedToken) {
                self.token = savedToken
            } else {
                self.isTokenExpired = true
                self.token = nil
            }
        } else {
            self.token = nil
        }
    }
    
    func checkIfTokenExpired() {
        if let currentToken = token, isTokenExpired(currentToken) {
            isTokenExpired = true
            token = nil
        }
    }

    private func isTokenExpired(_ token: Token) -> Bool {
        guard let expirationDate = token.expirationDate else {
            return false
        }
        return expirationDate <= Date()
    }
    
    //MARK: Authentication Requests
    func register(username: String, password: String) async throws -> Token {
        let request = try createRegisterRequest(username: username, password: password)
        let token = try await performNetworkRequest(request, responseType: Token.self)
        token.expirationDate = Token.defaultExpirationDate()
        self.token = token
        return token
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        let request = try createLoginRequest(username: username, password: password)
        let token = try await performNetworkRequest(request, responseType: Token.self)
        token.expirationDate = Token.defaultExpirationDate()
        self.token = token
        return token
    }
    
    func logOut() {
        token = nil
    }
    
    //MARK: Trip Requests
    func createTrip(with trip: TripCreate) async throws -> Trip {
        let request = try getTripRequest(type: .createTrip(trip), token: self.token)
        return try await performNetworkRequest(request, responseType: Trip.self)
    }
    
    func getTrips() async throws -> [Trip] {
        if !networkMonitor.isConnected {
            print("Offline: Attempting to load trips from cache...")
            return offlineCacheManager.loadTrips()
        }
        
        let request = try getTripRequest(type: .fetchTrips, token: self.token)
        
        do {
            let trips = try await performNetworkRequest(request, responseType: [Trip].self)
            offlineCacheManager.saveTrips(trips)
            return trips
        } catch {
            print("Error fetching trips. Loading from cache...")
            return offlineCacheManager.loadTrips()
        }
    }
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        let request = try getTripRequest(type: .getTrip(tripId), token: self.token)
        return try await performNetworkRequest(request, responseType: Trip.self)
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        let request = try getTripRequest(type: .updateTrip(tripId, request), token: self.token)
        return try await performNetworkRequest(request, responseType: Trip.self)
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        let request = try getTripRequest(type: .deleteTrip(tripId), token: self.token)
        return try await performVoidNetworkRequest(request)
    }
    
    //MARK: Event Requests
    func createEvent(with event: EventCreate) async throws -> Event {
        let request = try getEventRequest(type: .addEvent(event), token: self.token)
        return try await performNetworkRequest(request, responseType: Event.self)
    }
    
    func updateEvent(withId eventId: Event.ID, and event: EventUpdate) async throws -> Event {
        let request = try getEventRequest(type: .updateEvent(eventId, event), token: self.token)
        return try await performNetworkRequest(request, responseType: Event.self)
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        let request = try getEventRequest(type: .deleteEvent(eventId), token: self.token)
        return try await performVoidNetworkRequest(request)
    }
    
    //MARK: Media Requests
    func createMedia(with media: MediaCreate) async throws -> Media {
        let request = try getMediaRequest(type: .addMedia(media), token: self.token)
        return try await performNetworkRequest(request, responseType: Media.self)
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        let request = try getMediaRequest(type: .deleteMedia(mediaId.description), token: self.token)
        return try await performVoidNetworkRequest(request)
    }
    
    private func performNetworkRequest<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }

    private func performVoidNetworkRequest(_ request: URLRequest) async throws {
        let (_, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw NetworkError.badResponse
        }
    }
}
