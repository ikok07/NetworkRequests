//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation
import JSONCoder
import SwiftMacros
import UIKit


public extension Request {
    static func get<T: Codable>(url: String, authToken: String? = nil, showRawResponseData: Bool = false) async -> Result<T, NetworkError> {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        print("REQUEST URL: \(url)")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if showRawResponseData {
                print("RESPONSE RAW DATA: \(String(describing: String(data: data, encoding: .utf8)))")
            }
            let decodedData: T? = JSONCoder.decode(data)
            print("RESPONSE DATA: \(String(describing: decodedData))")
            if let decodedData {
                return .success(decodedData)
            }
        } catch {
            return .failure(.dataCouldNotBeDecoded)
        }
        
        return .failure(.networkError)
    }
}
