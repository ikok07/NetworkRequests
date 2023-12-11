//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation
import JSONCoder

public extension Request {
    func patch<T: Codable, B: Codable>(url: String, body: B, authToken: String? = nil) async -> Result<T, NetworkError> {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = JSONCoder.encode(body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: T? = JSONCoder.decode(data)
            if let decodedData {
                return .success(decodedData)
            }
        } catch {
            return .failure(.dataCouldNotBeDecoded)
        }
        
        return .failure(.networkError)
    }
}
