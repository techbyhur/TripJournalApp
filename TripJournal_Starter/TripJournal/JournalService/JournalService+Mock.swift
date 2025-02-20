import Combine
import Foundation

#warning("This file should be deleted before submitting the final project.")

#if DEBUG

/// A Mock implementation of the `JournalService`.
class MockJournalService: JournalService {
    private struct MockError: Error {}

    init(delay: TimeInterval = 0) {
        self.delay = delay
    }

    private let delay: TimeInterval
    private var trips: [Trip] = []

    @Published private var token: Token?

    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    func register(username _: String, password _: String) async throws -> Token {
        try await Task.sleep(for: .seconds(delay))
        let token = Token(accessToken: "", tokenType: "")
        self.token = token
        return token
    }

    func logIn(username _: String, password _: String) async throws -> Token {
        try await Task.sleep(for: .seconds(delay))
        let token = Token(accessToken: "", tokenType: "")
        self.token = token
        return token
    }

    func logOut() {
        token = nil
    }

    func createTrip(with request: TripCreate) async throws -> Trip {
        try await Task.sleep(for: .seconds(delay))
        let newTrip = Trip(
            id: UUID(),
            name: request.name,
            startDate: request.startDate,
            endDate: request.endDate,
            events: []
        )
        trips.append(newTrip)
        trips.sort()
        return newTrip
    }

    func getTrips() async throws -> [Trip] {
        try await Task.sleep(for: .seconds(delay))
        return trips
    }

    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        try await Task.sleep(for: .seconds(delay))
        guard let trip = trips.first(where: { $0.id == tripId }) else {
            throw MockError()
        }
        return trip
    }

    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        try await Task.sleep(for: .seconds(delay))
        guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else {
            throw MockError()
        }
        trips[tripIndex].update(from: request)
        trips.sort()
        return trips[tripIndex]
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        try await Task.sleep(for: .seconds(delay))
        trips.removeAll(where: { $0.id == tripId })
    }

    func createEvent(with request: EventCreate) async throws -> Event {
        try await Task.sleep(for: .seconds(delay))
        guard let tripIndex = trips.firstIndex(where: { $0.id == request.tripId }) else {
            throw MockError()
        }
        var events = trips[tripIndex].events
        let newEvent = Event(
            id: UUID(),
            name: request.name,
            note: request.note,
            date: request.date,
            location: request.location,
            medias: [],
            transitionFromPrevious: request.transitionFromPrevious
        )
        events.append(newEvent)
        trips[tripIndex].events = events
        trips[tripIndex].events.sort()
        return newEvent
    }

    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        try await Task.sleep(for: .seconds(delay))
        for tripIndex in trips.indices {
            for (eventIndex, event) in trips[tripIndex].events.enumerated() where event.id == eventId {
                trips[tripIndex].events[eventIndex].update(from: request)
                trips[tripIndex].events.sort()
                return trips[tripIndex].events[eventIndex]
            }
        }
        throw MockError()
    }

    func deleteEvent(withId eventId: Event.ID) async throws {
        try await Task.sleep(for: .seconds(delay))
        for tripIndex in trips.indices {
            for (eventIndex, event) in trips[tripIndex].events.enumerated() where event.id == eventId {
                trips[tripIndex].events.remove(at: eventIndex)
                return
            }
        }
        throw MockError()
    }

    @discardableResult
    func createMedia(with request: MediaCreate) async throws -> Media {
        try await Task.sleep(for: .seconds(delay))
        for tripIndex in trips.indices {
            for (eventIndex, event) in trips[tripIndex].events.enumerated() where event.id == request.eventId {
                let newMedia = Media.randomPlaceholder()
                trips[tripIndex].events[eventIndex].medias.append(newMedia)
                return newMedia
            }
        }
        throw MockError()
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {
        try await Task.sleep(for: .seconds(delay))
        for tripIndex in trips.indices {
            for eventIndex in trips[tripIndex].events.indices {
                for (mediaIndex, media) in trips[tripIndex].events[eventIndex].medias.enumerated() where media.id == mediaId {
                    trips[tripIndex].events[eventIndex].medias.remove(at: mediaIndex)
                    return
                }
            }
        }
        throw MockError()
    }
}

extension Event {
    func update(from update: EventUpdate) {
        name = update.name
        note = update.note
        date = update.date
        location = update.location
        transitionFromPrevious = update.transitionFromPrevious
    }

    static let amsterdam: [Event] = [
        .init(
            id: UUID(),
            name: "Canal Tour",
            note: nil,
            date: Date(day: 1, month: 6, year: 2024),
            location: .init(latitude: 52.3676, longitude: 4.9041, address: "Amsterdam"),
            medias: [
                .randomPlaceholder(),
                .randomPlaceholder(),
                .randomPlaceholder(),
            ],
            transitionFromPrevious: "Walk from Hotel"
        ),
        .init(
            id: UUID(),
            name: "Visit to the Van Gogh Museum",
            note: "A vivid, unforgettable art experience...",
            date: Date(day: 2, month: 6, year: 2024),
            location: .init(latitude: 52.3584, longitude: 4.8811, address: "Museumplein, Amsterdam"),
            medias: [
                .randomPlaceholder(),
                .randomPlaceholder(),
            ],
            transitionFromPrevious: "Tram ride from hotel"
        ),
        .init(
            id: UUID(),
            name: "Lunch",
            note: "The best pizza ever!",
            date: Date(day: 3, month: 6, year: 2024),
            location: nil,
            medias: [],
            transitionFromPrevious: nil
        ),
        .init(
            id: UUID(),
            name: "Evening at Dam Square",
            note: nil,
            date: Date(day: 4, month: 6, year: 2024),
            location: .init(latitude: 52.3731, longitude: 4.8936, address: "Dam Square, Amsterdam"),
            medias: [
                .randomPlaceholder(),
                .randomPlaceholder(),
            ],
            transitionFromPrevious: "Walk from the Jordaan neighborhood"
        ),
    ]

    static let rome: [Event] = [
        .init(
            id: UUID(),
            name: "Colosseum Tour",
            note: nil,
            date: Date(day: 10, month: 7, year: 2024),
            location: .init(latitude: 41.8902, longitude: 12.4922, address: "Rome"),
            medias: [
                .randomPlaceholder(),
            ],
            transitionFromPrevious: "Arrival in Rome"
        ),
        .init(
            id: UUID(),
            name: "Vatican Visit",
            note: nil,
            date: Date(day: 12, month: 7, year: 2024),
            location: .init(latitude: 41.9029, longitude: 12.4534, address: "Vatican City"),
            medias: [.randomPlaceholder()],
            transitionFromPrevious: "Metro from Rome"
        ),
    ]

    static let tokyo: [Event] = [
        .init(
            id: UUID(),
            name: "Shinjuku Exploration",
            note: nil,
            date: Date(day: 20, month: 8, year: 2024),
            location: .init(latitude: 35.6895, longitude: 139.6917, address: "Tokyo"),
            medias: [Media(id: UUID(), url: URL(string: "https://picsum.photos/id/1/640/360"))],
            transitionFromPrevious: "Arrival at Haneda Airport"
        ),
        .init(
            id: UUID(),
            name: "Sushi Tasting",
            note: nil,
            date: Date(day: 22, month: 8, year: 2024),
            location: .init(latitude: 35.6895, longitude: 139.6917, address: "Tokyo"),
            medias: [.randomPlaceholder()],
            transitionFromPrevious: "Walk through Tsukiji"
        ),
    ]

    static let paris: [Event] = [
        .init(
            id: UUID(),
            name: "Eiffel Tower Visit",
            note: nil,
            date: Date(day: 5, month: 9, year: 2024),
            location: .init(latitude: 48.8584, longitude: 2.2945, address: "Paris"),
            medias: [
                .randomPlaceholder(),
                .randomPlaceholder(),
                .randomPlaceholder(),
                .randomPlaceholder(),
                .randomPlaceholder(),
                .randomPlaceholder()
            ],
            transitionFromPrevious: "Arrival at Charles de Gaulle"
        ),
        .init(
            id: UUID(),
            name: "Louvre Museum Tour",
            note: nil,
            date: Date(day: 7, month: 9, year: 2024),
            location: nil,
            medias: [],
            transitionFromPrevious: "Metro ride from hotel"
        ),
    ]
}

extension Media {
    static func randomPlaceholder() -> Self {
        let id = UUID()
        return Self(id: id, url: URL(string: "https://picsum.photos/id/\(id)/640/360"))
    }
}

extension Trip {
    func update(from update: TripUpdate) {
        name = update.name
        startDate = update.startDate
        endDate = update.endDate
    }

    static let sample: [Trip] = {
        let amsterdamAdventure = Trip(
            id: UUID(),
            name: "Amsterdam Adventure",
            startDate: Date(day: 1, month: 6, year: 2024),
            endDate: Date(day: 5, month: 6, year: 2024),
            events: Event.amsterdam
        )

        let romeRetreat = Trip(
            id: UUID(),
            name: "Rome Retreat",
            startDate: Date(day: 10, month: 7, year: 2024),
            endDate: Date(day: 15, month: 7, year: 2024),
            events: Event.rome
        )

        let tokyoTour = Trip(
            id: UUID(),
            name: "Tokyo Tour",
            startDate: Date(day: 20, month: 8, year: 2024),
            endDate: Date(day: 25, month: 8, year: 2024),
            events: Event.tokyo
        )

        let parisPilgrimage = Trip(
            id: UUID(),
            name: "Paris Pilgrimage",
            startDate: Date(day: 5, month: 9, year: 2024),
            endDate: Date(day: 10, month: 9, year: 2024),
            events: Event.paris
        )

        return [amsterdamAdventure, romeRetreat, tokyoTour, parisPilgrimage]
    }()
}

private extension Date {
    init(day: Int, month: Int, year: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        guard let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Invalid date components: \(year)-\(month)-\(day)")
        }
        self = date
    }
}

#endif
