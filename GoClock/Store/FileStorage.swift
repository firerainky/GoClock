//
//  FileStorage.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation

@propertyWrapper
struct FileStorage<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    
    init(directory: FileManager.SearchPathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }
        
        get { value }
    }
}

@propertyWrapper
struct FileStorageDefault<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    let defaultValue: T
    
    init(directory: FileManager.SearchPathDirectory,
         fileName: String,
         defaultValue: T) {
        
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        set {
            value = newValue
            try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
        }
        
        get { value ?? defaultValue }
    }
}
