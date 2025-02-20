//
//  ServiceHelper.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//

import Combine
import Foundation

enum HTTPMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
    case form = "application/x-www-form-urlencoded"
}

enum HTTPHeaders: String {
    case accept
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum NetworkError: Error {
    case badUrl
    case badResponse
    case failedToDecodeResponse
    case invalidValue
}

enum SessionError: Error {
    case expired
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .expired:
            return "Your session has expired. Please log in again."
        }
    }
}

enum RequestUrl {
    static let baseUrl = "http://localhost:8000/"

    case register
    case login
    case trips
    case handleTrip(String)
    case events
    case eventDetails(String)
    case media
    case deleteMedia(String)

    private var requestUrl: String {
        switch self {
        case .register:
            return RequestUrl.baseUrl + "register" //POST
        case .login:
            return RequestUrl.baseUrl + "token" //POST
        case .trips:
            return RequestUrl.baseUrl + "trips" //POST & GET
        case .handleTrip(let tripId):
            return RequestUrl.baseUrl + "trips/\(tripId)" //GET & PUT & DELETE
        case .events:
            return RequestUrl.baseUrl + "events" //POST
        case .eventDetails(let eventId):
            return RequestUrl.baseUrl + "events/\(eventId)" //GET & PUT & DELETE
        case .media:
            return RequestUrl.baseUrl + "media" //POST
        case .deleteMedia(let mediaId):
            return RequestUrl.baseUrl + "media/\(mediaId)" //DELETE
        }
    }

    var url: URL {
        guard let tempUrl: URL = URL(string: requestUrl) else {
            fatalError("Invalid URL")
        }
        return tempUrl
    }
}
