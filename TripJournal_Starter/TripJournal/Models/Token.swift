//
//  Token.swift
//  TripJournal
//
//  Created by Ila Hur on 2/19/25.
//
import SwiftData

/// Represents  a token that is returns when the user authenticates.
@Model
final class Token: Codable {
    
    let accessToken: String
    let tokenType: String
    
    init(accessToken: String, tokenType: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
    }
    
    init(from decoder: any Decoder) throws {
#warning("Update with accurate decoding logic")
        self.accessToken = ""
        self.tokenType = ""
    }
    
    func encode(to encoder: any Encoder) throws {
#warning("Encode to JSON Object")
    }
}
