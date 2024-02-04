//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation

public enum NetworkError: String, Error, CaseIterable, Codable {
    
    case dataCouldNotBeDecoded = "Network Request Error: Data could not be decoded."
    case networkError = "Network Request Error: Error connecting to server"
    case noConnection = "There is no internet connection"
    
}
