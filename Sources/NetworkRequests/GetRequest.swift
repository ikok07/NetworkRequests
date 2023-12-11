//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation


@available(iOS 15.0, *)
extension Request {
    
    static func get<T: Codable>(url: String, authToken: String? = nil) async -> Result<T, Error> {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
        } catch {
            
        }
    }
    
}
