//
//  EventRequests.swift
//  TripJournal
//
//  Created by Ila Hur on 2/20/25.
//

import Combine
import Foundation

private let dateFormatter = ISO8601DateFormatter()

enum EventRequests {
    case addEvent(EventCreate)
    case getEvent(Event.ID)
    case updateEvent(Event.ID, EventUpdate)
    case deleteEvent(Event.ID)
}

func getEventRequest(type request: EventRequests, token: Token?) throws -> URLRequest {
    guard let localToken: Token = token else {
        throw NetworkError.invalidValue
    }
    
    return switch request {
    case .addEvent(let eventDetails):
        try getAddEventPOSTRequest(with: eventDetails, token: localToken)
    case .getEvent(let eventId):
        getEventDetailsGETRequest(with: eventId.description, token: localToken)
    case .updateEvent(let eventId, let eventDetails):
        try getUpdateEventPUTRequest(with: eventId.description, token: localToken, event: eventDetails)
    case .deleteEvent(let eventId):
        try getDeleteEventRequest(with: eventId.description, token: localToken)
    }
}

private func getAddEventPOSTRequest(with event: EventCreate, token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.events.url)
    requestURL.httpMethod = HTTPMethods.POST.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
    
    dateFormatter.formatOptions = [.withInternetDateTime]
    
    var eventData: [String: Any] = [
        "name": event.name,
        "date": dateFormatter.string(from: event.date),
        "note": event.note ?? "",
        "transition_from_previous": event.transitionFromPrevious ?? "",
        "trip_id": event.tripId
    ]
    
    if (event.location != nil) {
        let eventLocationData: [String: Any] = [
            "latitude": event.location!.latitude,
            "longitude": event.location!.longitude,
            "address": event.location?.address ?? ""
        ]
        eventData["location"] = eventLocationData
    }
    
    requestURL.httpBody = try JSONSerialization.data(withJSONObject: eventData)
    return requestURL
}

private func getEventDetailsGETRequest(with eventId: String, token: Token) -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.eventDetails(eventId).url)
    requestURL.httpMethod = HTTPMethods.GET.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}

private func getUpdateEventPUTRequest(with eventId: String, token: Token, event: EventUpdate) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.eventDetails(eventId).url)
    requestURL.httpMethod = HTTPMethods.PUT.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
    
    var eventData: [String: Any] = [
        "name": event.name,
        "date": dateFormatter.string(from: event.date),
        "note": event.note ?? "",
        "transition_from_previous": event.transitionFromPrevious ?? "",
        "trip_id": event.tripId
    ]
    
    if (event.location != nil) {
        let eventLocationData: [String: Any] = [
            "latitude": event.location!.latitude,
            "longitude": event.location!.longitude,
            "address": event.location?.address ?? ""
        ]
        eventData["location"] = eventLocationData
    }
    
    requestURL.httpBody = try JSONSerialization.data(withJSONObject: eventData)
    return requestURL
}

private func getDeleteEventRequest(with eventId: String, token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.eventDetails(eventId).url)
    requestURL.httpMethod = HTTPMethods.DELETE.rawValue
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}
