//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import Foundation

public enum NetworkError: String, Error, LocalizedError {
    
    case dataCouldNotBeDecoded
    case networkError
    case noConnection
    
    public var errorDescription: String? {
        switch self {
        case .dataCouldNotBeDecoded:
            NSLocalizedString("Network Request Error: Data could not be decoded.", comment: self.rawValue)
        case .networkError:
            NSLocalizedString("Network Request Error: Error connecting to server", comment: self.rawValue)
        case .noConnection:
            NSLocalizedString("There is no internet connection", comment: self.rawValue)
        }
    }
}
