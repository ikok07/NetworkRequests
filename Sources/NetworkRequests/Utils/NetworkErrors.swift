//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation

public enum NetworkError: LocalizedError {
    
    case dataCouldNotBeDecoded
    case networkError
    case noConnection
    
    var localizedDescription: String {
        switch self {
        case .dataCouldNotBeDecoded:
            "Network Request Error: Data could not be decoded."
        case .networkError:
            "Network Request Error: Error connecting to server"
        case .noConnection:
            "There is no internet connection"
        }
    }
    
}
