//
//  CCKVStorage.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/13.
//  Copyright © 2020 stormVCC. All rights reserved.
//
import SQLite3


/**
 每个path下，都有data和trash文件夹，其中data是存放数据的文件缓存，文件名通过md5加密，trash则是丢弃的缓存文件的文件夹。path下的manifest.sqlite是数据库文件，manifest.sqlite-shm和manifest.sqlite-wal是sqlite数据库WAL机制所需文件。
 WAL机制：在写数据时，并不是直接操作数据库文件，而是操作一个WAL文件，这样当我们插入、删除数据时，只是写一条操作语句到WAL文件，当WAL文件到达一定量级（默认1000page）时，sqlite就会把数据同步到数据库文件中。其带来的不足之处时读数据时，可能要同事考虑到WAL文件与数据库文件，所以读数据性能会有一定下降。但这个对于移动端的数据量来说表现得并不明显。所以数据库在删除数据后，数据库文件大小有时候反而会增大，但并不会无限制增大，当增长到一定数量时，就会变小。
 
 文件路径：
 /manifest.sqlite
 /manifest.sqlite-shm
 /manifest.sqlite-wal
 /data/..
 /trash/..
 
 sqlite3_stmt，C接口中“准备语句对象”，该对象是一条SQL语句的实例，而且该语句已经编译成二进制形式，可以直接进行计算。
 OpaquePointer，如果一个C指针类型无法在Swift中找到对应的类型，可以用这个指针来表达。
 
 manifest(
 key                text,
 filename           text,
 size               integer,
 inline_data        blob,
 modification_time  integer,
 last_access_time   integer,
 extended_data      integer,
 extended_data      blob,
 primary key(key)
 )
 
 SqLite3使用过程；
 sqlite3_open：打开一个sqlite数据库文件的连接并返回一个数据库连接对象。
 sqlite3_prepare:将sql文件转换成一个stmt准备语句对象，返回这个对象的指针。这个接口需要一个数据库连接指针以及一个要准备的包含SQL语句的文本。他并不执行SQL语句，只是准备这个SQL语句，sqlite3_prepare执行代价较为昂贵，所以通常尽可能的重用prepare语句。
 sqlite3_step:用于执行sqlite3_prepare创建的准备语句。这个语句执行到结果的第一行柯勇的位置，继续前进到结果的第二行的话，只需在此调用sqlite3_step，直到语句完成。
 sqlite3_column:每次sqlite3_step得到一个结果集的列停下后，这个过程就可以被多次调用去查询这个行的各列的值。
 sqlite3_finalize:这个函数销毁前面被sqlite3_prepare创建的准备语句，每个准备语句都必须使用这个函数去销毁以防止内存泄漏。
 sqlite3_close:这个函数关闭前面使用sqlite3_open打开的数据库连接，任何与这个连接相关的准备语句必须在调用这个关闭函数之前被释放。
 */


/**缓存相关参数*/
class CCKVStorageItem{
    public var key = ""                         //缓存键
    public var value = Data()                   //缓存值
    public var filename: String?                //缓存文件名
    public var size = 0                         //缓存大小
    public var modTime = 0                      //修改时间
    public var accessTime = 0                   //最后使用时间
    public var extendedData: Data? = nil        //扩展数据
}

// 缓存操作实现
class CCKVStorage{
    private let limit: (maxErrorRetryCount: Int, minRetryTimeInterval: TimeInterval) = (8, 2)
    private let dbFileName = "manifest.sqlite"
    private let dbShmFileName = "manifest.sqlite-shm"
    private let dbWalFileName = "manifest.sqlite-wal"
    private let dataDirectorName = "data"
    private let trashDirectoryName = "trash"
    
    private(set) var path = ""           //外部传入的数据库存储位置
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
                    //遍历所有未完成的准备好的语句并完成他们
                    while let stmt = sqlite3_next_stmt(_db, nil){
                        sqlite3_finalize(stmt)
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


extension CCKVStorage{
    /**
     通过item的参数保存 key value filename extendedData
     */
    public func saveItem(_ item: CCKVStorageItem) -> Bool{
        return saveItem(with: item.key, value: item.value, filename: item.filename, extendedData: item.extendedData)
    }
    
    public func saveItem(with key: String?, value: Data?) -> Bool{
        
        return saveItem(with: key, value: value, filename: nil, extendedData: nil)
    }
    
    public func saveItem(with key: String?, value: Data?, filename: String?, extendedData: Data?) -> Bool{
        return true
    }
    
    public func removeItem(for key: String?) -> Bool{
        return true
    }
    
    public func removeItem(for keys: Array<String>) -> Bool{
        return true
    }
    
    public func removeItemsLargerThanSize(_ size: Int) -> Bool{
        return true
    }
    
    public func removeItemsEarlierThanTime(_ time: Int) -> Bool{
        return true
    }
    
    public func removeItemsToFitSize(_ maxSize: Int) -> Bool{
        return true
    }
    
    public func removeItemsToFitCount(_ maxCount: Int) -> Bool{
        return true
    }
    
    public func removeAllItems() -> Bool{
        return true
    }
}
