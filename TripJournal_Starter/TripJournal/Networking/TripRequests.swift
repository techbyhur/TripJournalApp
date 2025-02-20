//
//  TripRequests.swift
//  TripJournal
//
//  Created by Ila Hur on 2/20/25.
//

import Combine
import Foundation

private let dateFormatter = ISO8601DateFormatter()

enum TripRequests {
    case fetchTrips
    case createTrip(TripCreate)
    case getTrip(Trip.ID)
    case updateTrip(Trip.ID, TripUpdate)
    case deleteTrip(Trip.ID)
}

func getTripRequest(type request: TripRequests, token: Token?) throws -> URLRequest {
    guard let localToken: Token = token else {
        throw NetworkError.invalidValue
    }
    
    return switch request {
    case .fetchTrips:
        getFetchTripsGETRequest(token: localToken)
    case .createTrip(let tripDetails):
        try getCreateTripPOSTRequest(with: tripDetails, token: localToken)
    case .getTrip(let tripId):
        try getTripDetailsGETRequest(tripId: tripId.description, with: localToken)
    case .updateTrip(let tripId, let tripDetails):
        try getUpdateTripPUTRequest(tripId: tripId.description, tripDetails: tripDetails, with: localToken)
    case .deleteTrip(let tripId):
        try getDeleteTripRequest(tripId: tripId.description, with: localToken)
    }
}

private func getFetchTripsGETRequest(token: Token) -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.trips.url)
    requestURL.httpMethod = HTTPMethods.GET.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}

private func getCreateTripPOSTRequest(with tripDetails: TripCreate, token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.trips.url)
    requestURL.httpMethod = HTTPMethods.POST.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

    dateFormatter.formatOptions = [.withInternetDateTime]
    
    print("start date: \(dateFormatter.string(from: tripDetails.startDate))")
    print("end date: \(dateFormatter.string(from: tripDetails.endDate))")
    
    let tripData: [String: Any] = [
        "name": tripDetails.name,
        "start_date": dateFormatter.string(from: tripDetails.startDate),
        "end_date": dateFormatter.string(from: tripDetails.endDate)
    ]
    requestURL.httpBody = try JSONSerialization.data(withJSONObject: tripData)
    
    return requestURL
}

private func getTripDetailsGETRequest(tripId: String, with token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.handleTrip(tripId).url)
    requestURL.httpMethod = HTTPMethods.GET.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}

private func getUpdateTripPUTRequest(tripId: String, tripDetails: TripUpdate, with token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.handleTrip(tripId).url)
    requestURL.httpMethod = HTTPMethods.PUT.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

    dateFormatter.formatOptions = [.withInternetDateTime]
    
    let tripData: [String: Any] = [
        "name": tripDetails.name,
        "start_date": dateFormatter.string(from: tripDetails.startDate),
        "end_date": dateFormatter.string(from: tripDetails.endDate)
    ]
    requestURL.httpBody = try JSONSerialization.data(withJSONObject: tripData)
    
    return requestURL
}

private func getDeleteTripRequest(tripId: String, with token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.handleTrip(tripId.description).url)
    requestURL.httpMethod = HTTPMethods.DELETE.rawValue
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}
