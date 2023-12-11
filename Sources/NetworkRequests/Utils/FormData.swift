//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import UIKit
import JSONCoder

struct FormData {
    
    static func patchFormData<T: Codable>(url: String, json: Data? = nil, images: [UIImage]? = nil, authToken: String? = nil) async -> Result<T?, NetworkError> {
        
        let boundary = FormData.generateBoundary()
        var imagesData: [Data] = []
        
        if let images {
            imagesData = images.map({ ImageMedia(withImage: $0, key: "image").data ?? .init() })
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = FormData.createBody(json: json, images: imagesData, boundary: boundary)
        
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
    
    
    static func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    static func createBody(json: Data?, images: [Data]?, boundary: String) -> Data {
        var body = Data()
        
        if let json = json {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(json)
        }
        
        if let images = images {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            
            for image in images {
                body.append(image)
            }
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
}
