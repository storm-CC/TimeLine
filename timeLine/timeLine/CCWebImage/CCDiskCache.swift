//
//  CCDiskCache.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/13.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class CCDiskCache {
    public var name = ""
    private(set) var path = ""
    public var countLimit = 0
    public var costLimit = 0
    public var ageLimit: TimeInterval = 0
    
    private var kv = CCKVStorage.init(path: "")
    
    fileprivate let lock = DispatchSemaphore.init(value: 0)
    fileprivate let queue = DispatchQueue.init(label: "com.cc.cache.disk")
    
    
    /**缓存单例*/
    fileprivate static let globalInstances = NSMapTable<NSString, CCDiskCache>.init(keyOptions: .strongMemory, valueOptions: .weakMemory, capacity: 0)
    fileprivate static let globalInstancesLock = DispatchSemaphore.init(value: 1)
    
    fileprivate static func diskCacheGetGlobal(_ path: String?) -> CCDiskCache?{
        guard let path = path as NSString? else { return nil }
        let _ = globalInstancesLock.wait(timeout: .distantFuture)
        let cache = globalInstances.object(forKey: path)
        CCDiskCache.globalInstancesLock.signal()
        return cache
    }
    fileprivate static func diskCacheSetGlobal(_ cache: CCDiskCache){
        if cache.path.count <= 0 { return }
        globalInstancesLock.wait()
        globalInstances.setObject(cache, forKey: cache.path as NSString)
        globalInstancesLock.signal()
    }
    
    private init(){}
    
    public static func diskCache(with path: String?) -> CCDiskCache?{
        guard let path = path else { return nil }
        if let globalCache = self.diskCacheGetGlobal(path){
            return globalCache
        }
        let cache = CCDiskCache()
        cache.path = path
        cache.kv = CCKVStorage.init(path: path)
        return cache
    }
    
    
    public func containsObject(for key: String?) -> Bool{
        guard let key = key, key.count <= 0 else { return false }
        lock.wait()
        
        lock.signal()
        return true
    }
}


extension CCDiskCache{
//    public func getItemForKey(_ key: String?) -> CCKVStorage {
//        guard let key = key, key.count <= 0 else { return }
//
//    }
}
