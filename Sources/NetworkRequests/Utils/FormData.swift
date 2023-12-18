//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import UIKit
import JSONCoder

public extension Request {
    static func patchFormData<T: Codable>(url: String, json: Data? = nil, images: [UIImage?], authToken: String? = nil) async -> Result<T, NetworkError> {
        
        let boundary = FormData.generateBoundary()
        var imagesData: [Data] = []
        
        imagesData = images.map({ ImageMedia(withImage: $0, key: "image").data ?? .init() })
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = FormData.createBody(json: json, images: imagesData, boundary: boundary)
        print("REQUEST DATA: \(String(data: FormData.createBody(json: json, images: imagesData, boundary: boundary), encoding: .utf8))")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: T? = JSONCoder.decode(data)
            print("DECODED DATA: \(String(describing: decodedData))")
            if let decodedData {
                return .success(decodedData)
            }
        } catch {
            return .failure(.dataCouldNotBeDecoded)
        }
        
        return .failure(.networkError)
        
    }
}

public struct FormData {
    
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
            body.append("\r\n".data(using: .utf8)!)
        }

        if let images = images {
            for imageData in images {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
}
