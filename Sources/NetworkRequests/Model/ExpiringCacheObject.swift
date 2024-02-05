//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import Foundation
import JSONCoder
import RealmSwift


/// - key: "param_param..."
final class ExpiringCacheObject: Object, Codable {
    @Persisted(primaryKey: true) var key: String
    @Persisted var data: Data?
    @Persisted var expireDate: Date
    
    var isExpired: Bool {
        Date.now > self.expireDate
    }
    
    func decodedData<T: Codable>(_ some: T.Type) -> T? {
        if let data {
            return JSONCoder.decode(data)
        }
        return nil
    }
    
    init<T: Codable>(
        object: T,
        params: [String],
        expireDate: Date?
    ) {
        var key: String = .init()
        for param in params {
            key.append("\(param)_")
        }
        self.data = JSONCoder.encode(object)
        self.expireDate = expireDate ?? Calendar.current.date(byAdding: .hour, value: 24, to: .now)!
    }
}
