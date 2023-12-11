//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation
import JSONCoder

public extension Request {
    static func delete<T: Codable>(url: String, authToken: String? = nil) async -> Result<T, NetworkError> {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        
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
