//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import Foundation
import RealmSwift


struct CacheManager: CacheManagerProtocol {
    func syncStore<T>(_ codable: T, params: [String], timeToLiveMinutes: Int?) where T : Decodable, T : Encodable {
        var expireDate: Date?
        if let timeToLiveMinutes {
            expireDate = Calendar.current.date(byAdding: .minute, value: timeToLiveMinutes, to: .now)
        }
        
        let expiringCacheObject = ExpiringCacheObject(object: codable, params: params, expireDate: expireDate)
        
        RealmManager.shared.save(expiringCacheObject)
    }
    
    func syncRetrieve<T>(_ type: T.Type, key: String) -> T? where T : Decodable, T : Encodable {
        let cachedObjects: Results<ExpiringCacheObject>? = RealmManager.shared.fetch()
        
        let objectToRetrieve = cachedObjects?.first(where: { $0.key == key }) as? T
        if let objectToRetrieve {
            return objectToRetrieve
        }
        return nil
    }
    
    
}
