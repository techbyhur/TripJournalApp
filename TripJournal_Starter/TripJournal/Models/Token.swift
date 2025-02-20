//
//  Token.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import Foundation
import SwiftData

/// Represents  a token that is returns when the user authenticates.
@Model
final class Token: Codable {
    
    var accessToken: String
    var tokenType: String
    var expirationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case tokenExpirationDate
    }
    
    static func defaultExpirationDate() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        return calendar.date(byAdding: .minute, value: 5, to: currentDate) ?? currentDate
    }
    
    init(accessToken: String, tokenType: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try values.decode(String.self, forKey: .accessToken)
        self.tokenType = try values.decode(String.self, forKey: .tokenType)
        self.expirationDate = try values.decodeIfPresent(Date.self, forKey: .tokenExpirationDate)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(expirationDate, forKey: .tokenExpirationDate)
    }
}
