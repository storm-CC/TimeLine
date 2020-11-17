//
//  CCKVStorage.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/13.
//  Copyright © 2020 stormVCC. All rights reserved.
//
import SQLite3
//import Foundation

/**
 sqlite3_stmt，C接口中“准备语句对象”，该对象是一条SQL语句的实例，而且该语句已经编译成二进制形式，可以直接进行计算。
 OpaquePointer，如果一个C指针类型无法在Swift中找到对应的类型，可以用这个指针来表达，
 */

class CCKVStorage{
    
    private let limit: (maxErrorRetryCount: Int, minRetryTimeInterval: TimeInterval) = (8, 2)
    private let dbFileName = "manifest.sqlite"
    private let dbShmFileName = "manifest.sqlite-shm"
    private let dbWalFileName = "manifest.sqlite-wal"
    private let dataDirectorName = "data"
    private let trashDirectoryName = "trash"
    
    
    private var path = ""           //外部传入的数据库存储位置
    private var dbPath = ""         //数据库文件地址
    private var dataPath = ""       //data地址
    private var trashPath = ""      //trash地址
    private var db: OpaquePointer?  //数据库变量
    
    private var dbStmtCache: Dictionary<String, Any>? = [:]
    private var dbLastOpenErrorTime: TimeInterval = 0
    private var dbOpenErrorCount = 0
    
    private init(){}
    
    convenience init(path: String) {
        self.init()
        self.path = path
        dataPath = path.appending("/\(dataDirectorName)")
        trashPath = path.appending("/\(trashDirectoryName)")
        dbPath = path.appending("/manifest.sqlite")
        do{
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: trashPath, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("KVStorage init error: \(error)")
            return
        }
        
        if !dbOpen() || !dbInitialize() {
            dbClose()
            reset()
            if !dbOpen() || !dbInitialize() {
                dbClose()
                print("KVStorage init error: fail to open sqlite db")
                return
            }
        }
        fileEmptyTrashInBackground()
    }
}



extension CCKVStorage{
    /**数据库连接*/
    private func dbOpen() -> Bool{
        if db != nil {
            return true
        }
        if sqlite3_open(dbPath, &db) == SQLITE_OK{
            dbLastOpenErrorTime = 0
            dbOpenErrorCount = 0
            return true
        }else{
            //打开失败就归零数据
            db = nil
            dbStmtCache = nil
            dbLastOpenErrorTime = CACurrentMediaTime()
            dbOpenErrorCount += 1
            return false
        }
    }
    /**关闭数据库*/
    @discardableResult
    private func dbClose() -> Bool {
        guard let _db = db else { return true }
        var result: Int32 = 0
        var retry = false
        var stmtFinalized = false
        dbStmtCache = nil
        //循环去关闭数据库
        repeat{
            retry = false
            result = sqlite3_close(_db)
            if result == SQLITE_BUSY || result == SQLITE_LOCKED {           //如果数据库关闭失败，则销毁数据库中的每条记录，然后再关闭数据库。
                if !stmtFinalized{
                    stmtFinalized = true
                    while let stmt = sqlite3_next_stmt(_db, nil), stmt != OpaquePointer.init(bitPattern: 0) {
                        sqlite3_finalize(stmt)      //销毁前面创建的stmt准备语句，每个准备语句都必须使用这个函数去销毁避免内存泄漏。
                        retry = true
                    }
                }
            }else if result != SQLITE_OK{
                print("sqlite close failed!")
            }
        }while(retry)
            
        db = nil
        return true
    }
    /**检查数据库是否完好*/
    private func dbCheck() -> Bool {
        if db == nil {
            if dbOpenErrorCount < limit.maxErrorRetryCount, CACurrentMediaTime() - dbLastOpenErrorTime > limit.minRetryTimeInterval {
                return dbOpen() && dbInitialize()
            }else{
                return false
            }
        }
        return true
    }
    /**数据库初始化*/
    private func dbInitialize() -> Bool{
        let sql = "pragma journal_mode = wal; pragma synchronous = normal; create table if not exists manifest (key text, filename text, size integer, inline_data blob, modification_time integer, last_access_time integer, extended_data blob, primary key(key)); create index if not exists last_access_time_idx on manifest(last_access_time);"
        return dbExecute(sql)
    }
    /**执行sql语句*/
    private func dbExecute(_ sql: String?) -> Bool{
        guard let sql = sql, sql.count > 0, !dbCheck() else {return false}
        var error: UnsafeMutablePointer<Int8>?
        let result = sqlite3_exec(db, sql, nil, nil, &error)
        if let error = error{
            print("\(#function) line: \(#line) sqlite exex error \(result): \(error)")
            sqlite3_free(error)
        }
        return result == SQLITE_OK
    }
    /***/
    @discardableResult
    private func fileMoveAllToTrash() -> Bool{
        let uuidStr = UUID.init().uuidString
        let tmpPath = trashPath.appending("/\(uuidStr)")
        do {
            try FileManager.default.moveItem(atPath: dataPath, toPath: tmpPath)
        } catch {
            do{
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                return false
            }
        }
        return true
    }
    private func fileEmptyTrashInBackground(){
        
    }
    /**重置数据库*/
    private func reset() {
        do {
            try FileManager.default.removeItem(atPath: path.appending("/\(dbFileName)"))
            try FileManager.default.removeItem(atPath: path.appending("/\(dbShmFileName)"))
            try FileManager.default.removeItem(atPath: path.appending("/\(dbWalFileName)"))
        } catch {}
        fileMoveAllToTrash()
        fileEmptyTrashInBackground()
    }
    
    
}
