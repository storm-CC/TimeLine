//
//  CCMemoryCache.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/12.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

/**
 图片缓存节点
 */
class CCLinkedMapNode: Equatable{
    var prev: CCLinkedMapNode?
    var next: CCLinkedMapNode?
    var time: TimeInterval = 0
    var cost: Int = 0
    var key: String = ""
    var value: CCLinkedMapNode?
    
    static func == (lhs: CCLinkedMapNode, rhs: CCLinkedMapNode) -> Bool {
        return lhs.prev  == rhs.prev
            && lhs.next  == rhs.next
            && lhs.time  == rhs.time
            && lhs.cost  == rhs.cost
            && lhs.key   == rhs.key
            && lhs.value == rhs.value
    }
}

/**
 图片缓存双链表
 */
class CCLinkedMap{
    var dic: Dictionary<String, CCLinkedMapNode> = [:]
    var head: CCLinkedMapNode?          //表头元素
    var tail: CCLinkedMapNode?          //表尾元素
    
    var totalCost: Int = 0      //图片缓存
    var totalCount: Int = 0     //图片总数
    
    
    /**表头插入元素*/
    public func insertNodeAtHead(_ node: CCLinkedMapNode?){
        guard let node = node else {return }
        dic[node.key] = node
        totalCost += node.cost
        totalCount += 1
        if head == nil{
            tail = node
            head = tail
        }else{
            node.next = head
            head?.prev = node
            head = node
        }
    }
    
    /**将node放到表头*/
    public func bringNodeToHead(_ node: CCLinkedMapNode?){
        guard let node = node else { return }
        if node == head { return }
        if node == tail{
            let _tail = tail?.prev
            _tail?.next = nil
            tail = _tail
        }else{
            let lNode = node.prev
            let rNode = node.next
            lNode?.next = rNode
            rNode?.prev = lNode
        }
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
    }
    
    /**删除节点*/
    public func removeNode(_ node: CCLinkedMapNode?) {
        guard let node = node else { return }
        self.dic.removeValue(forKey: node.key)
        totalCost -= node.cost
        totalCount -= 1
        node.prev?.next = node.next
        node.next?.prev = node.prev
        if node == head{
            head = node.next
        }
        if node == tail{
            tail = node.prev
        }
    }
    
    /**删除链尾节点*/
    public func removeTailNode() -> CCLinkedMapNode? {
        guard let _tail = tail else { return nil }
        removeNode(_tail)
        return _tail
    }
    
    public func removeAll(){
        totalCost = 0
        totalCount = 0
        head = nil
        tail = nil
        if dic.count > 0{
            dic.removeAll()
        }
    }
}

class CCMemoryCache{
    var lru: CCLinkedMap = CCLinkedMap()
    var queue: DispatchQueue = DispatchQueue.init(label: "com.cc.cache.memory")
    var lock: pthread_mutex_t!
    
    public init() {
        pthread_mutex_init(&lock, nil)
        //循环检查缓存是否超限
    }
    
    public func totalCount() -> Int{
        pthread_mutex_lock(&lock)
        let count = lru.totalCount
        pthread_mutex_unlock(&lock)
        return count
    }
    
    public func totalCost() -> Int{
        pthread_mutex_lock(&lock)
        let cost = lru.totalCost
        pthread_mutex_unlock(&lock)
        return cost
    }
    
    public func setObject(objc: CCLinkedMapNode?, key: String?){
        guard let key = key else { return }
        guard let objc = objc else { removeObject(for: key); return}
        pthread_mutex_lock(&lock)
        if let node = lru.dic[key]{        //链表中存在此node
            lru.totalCost -= node.cost
            lru.totalCost += objc.cost
            node.cost = objc.cost
            node.time = CACurrentMediaTime()
            node.value = node
            lru.bringNodeToHead(node)
        }else{
            let node = CCLinkedMapNode()
            node.cost = objc.cost
            node.time = CACurrentMediaTime()
            node.key = key
            node.value = objc
            lru.insertNodeAtHead(node)
        }
    }
    
    public func removeObject(for key: String?){
        guard let key = key else { return }
        pthread_mutex_lock(&lock)
        if let node = lru.dic[key]{
            lru.removeNode(node)
        }
        pthread_mutex_unlock(&lock)
    }
    
}


