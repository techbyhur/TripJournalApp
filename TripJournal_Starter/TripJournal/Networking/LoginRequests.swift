//
//  LoginRequest.swift
//  TripJournal
//
//  Created by Ila Hur on 2/20/25.
//

import Combine
import Foundation

func createRegisterRequest(username: String, password: String) throws -> URLRequest {
    var request = URLRequest(url: RequestUrl.register.url)
    request.httpMethod = HTTPMethods.POST.rawValue
    request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

    let registerRequest = LoginRequest(username: username, password: password)
    request.httpBody = try JSONEncoder().encode(registerRequest)

    return request
}

func createLoginRequest(username: String, password: String) throws -> URLRequest {
    var request = URLRequest(url: RequestUrl.login.url)
    request.httpMethod = HTTPMethods.POST.rawValue
    request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
    request.addValue(MIMEType.form.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

    let loginData = "grant_type=&username=\(username)&password=\(password)"
    request.httpBody = loginData.data(using: .utf8)

    return request
}
