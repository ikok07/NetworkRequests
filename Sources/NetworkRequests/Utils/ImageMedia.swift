//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import UIKit

public struct ImageMedia: Codable {
    let key: String
    let data: Data?
    let mimeType: String
    
    init(withImage image: UIImage?, key: String, format: String = "jpeg") {
        self.key = key
        self.mimeType = "image/\(format)"
        self.data = image?.jpegData(compressionQuality: 0.3)
    }
}
