//
//  File.swift
//  
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    var realm = try? Realm()
    
    func save<T: Object> (_ object: Object, shouldBeOnlyOne: Bool = false, ofType type: T.Type? = nil) {
        do {
            if let type, shouldBeOnlyOne {
                try realm?.write {
                    let existingObjects = realm?.objects(T.self)
                    
                    if let existingObjects {
                        for object in existingObjects {
                            realm?.delete(object)
                        }
                    }
                    
                    realm?.add(object, update: .modified)
                }
            } else {
                try realm?.write {
                    realm?.add(object, update: .modified)
                }
            }
        } catch {
            print("FAILED SAVING MODEL TO REALM DB")
        }
    }
    
    func fetch<T: Object>() -> Results<T>? {
        return realm?.objects(T.self)
    }
}
