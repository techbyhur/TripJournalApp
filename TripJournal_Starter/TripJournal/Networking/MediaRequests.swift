//
//  MediaRequests.swift
//  TripJournal
//
//  Created by Ila Hur on 2/20/25.
//

import Combine
import Foundation

enum MediaRequests {
    case addMedia(MediaCreate)
    case deleteMedia(String)
}

func getMediaRequest(type request: MediaRequests, token: Token?) throws -> URLRequest {
    
    guard let localToken: Token = token else {
        throw NetworkError.invalidValue
    }
    
    return switch request {
    case .addMedia(let mediaCreate):
        try getAddMediaPOSTRequest(media: mediaCreate, token: localToken)
    case .deleteMedia(let mediaId):
        try getDeleteMediaPOSTRequest(mediaId: mediaId, token: localToken)
    }
}

private func getAddMediaPOSTRequest(media: MediaCreate, token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.media.url)
    requestURL.httpMethod = HTTPMethods.POST.rawValue
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
    
    var mediaData: [String: Any] = [
        "base64_data": media.base64Data.base64EncodedString(),
        "event_id": media.eventId
    ]
    requestURL.httpBody = try JSONSerialization.data(withJSONObject: mediaData)
    return requestURL
}

private func getDeleteMediaPOSTRequest(mediaId: String, token: Token) throws -> URLRequest {
    var requestURL = URLRequest(url: RequestUrl.deleteMedia(mediaId).url)
    requestURL.httpMethod = HTTPMethods.DELETE.rawValue
    requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
    
    return requestURL
}
