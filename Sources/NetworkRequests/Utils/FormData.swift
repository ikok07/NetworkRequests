//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import UIKit
import JSONCoder

public extension Request {
    static func formData<T: Codable>(httpMethod: String, url: String, json: Data?, image: UIImage?, authToken: String? = nil) async -> Result<T, NetworkError> {
        
        let boundary = FormData.generateBoundary()
        let imageData = ImageMedia(withImage: image, key: "image").data
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = httpMethod
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = FormData.createBody(json: json, image: imageData, boundary: boundary)
        print("REQUEST DATA: \(String(data: FormData.createBody(json: json, image: imageData, boundary: boundary), encoding: .utf8))")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("BEFORE DECODED DATA: \(String(describing: String(data: data, encoding: .utf8)))")
            let decodedData: T? = JSONCoder.decode(data)
//            print("DECODED DATA: \(String(describing: decodedData))")
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
    
    static func createBody(json: Data?, image: Data?, boundary: String) -> Data {
        var body = Data()
        
        if let json = json {
            let jsonDict: [String: Any]? = JSONCoder.serialize(json)
            if let dict = jsonDict {
                for (index, itm) in dict.enumerated() {
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(itm.key)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
                    body.append("\(itm.value)\(index < dict.count - 1 ? "\r\n" : "")".data(using: .utf8)!)
                }
            } else {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"name\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
                body.append(json)
            }
        }
        
        if let image = image {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(image)
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
        
    }
    
}
