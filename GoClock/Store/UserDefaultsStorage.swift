//
//  UserDefaultsStorage.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsStorage<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

//    var wrappedValue: T {
//        get {
//            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
    
    var wrappedValue: T {
            get {
                // Read value from UserDefaults
                guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                    // Return defaultValue when no data in UserDefaults
                    return defaultValue
                }

                // Convert data to the desire data type
                let value = try? JSONDecoder().decode(T.self, from: data)
                return value ?? defaultValue
            }
            set {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                
                // Set value to UserDefaults
                UserDefaults.standard.set(data, forKey: key)
            }
        }
}
