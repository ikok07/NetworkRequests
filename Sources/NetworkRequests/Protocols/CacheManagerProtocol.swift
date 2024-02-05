//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import Foundation

protocol CacheManagerProtocol {
    func syncStore<T: Codable>(_ codable: T, params: [String], timeToLiveMinutes: Int?)
    func syncRetrieve<T: Codable>(_ type: T.Type, key: String) -> T?
}
