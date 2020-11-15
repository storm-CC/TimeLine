//
//  CCKVStorage.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/13.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

import SQLite3

import Foundation

class CCKVStorage{
    private var path = ""
    private var dbPath = ""
    private var dataPath = ""
    private var trashPath = ""
    private var db: OpaquePointer?
    
    convenience init(path: String) {
        self.init()
        self.path = path
        dataPath = path.appending("/data")
        trashPath = path.appending("/trash")
        dbPath = path.appending("/manifest.sqlite")
        do{
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: trashPath, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("KVStorage init error: \(error)")
        }
        
        
        
    }
}



extension CCKVStorage{
    private func dbOpen() -> Bool{
        if db != nil {
            return true
        }
        let result = sqlite3_open(dbPath, &db)
        if result == SQLITE_OK{
            var keyCallbacks = CFDictionaryKeyCallBacks()
            var valueCallbacks = CFDictionaryValueCallBacks()
            let allocator: CFAllocator = CFAllocatorGetDefault()
            
            CFDictionaryCreateMutable(CFAllocatorGetDefault() as? CFAllocator, 0, &keyCallbacks, &valueCallbacks)
            return true
        }else{
            return false
        }
    }
}
