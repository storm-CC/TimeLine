//
//  TimeLineModel.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/21.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import HandyJSON
import Moya

//临时基类
open class CElement: CCItem, HandyJSON{
    public required override init() {
        super.init()
    }
    
    public func didFinishMapping() {
        
    }
    
    public func mapping(mapper: HelpingMapper) {
        
    }
    
    //通过其他数据，更新当前model
    func updateModel(model: Any) {
        
    }
}

//model可抽基类处理
public class TimeLineTweets: CElement{
    var tweets: Array<TimeLineTweet> = []
    
    //错误处理忽略。。。
    @discardableResult
    public static func getInfo(_ completion: ((TimeLineTweets?) ->())? = nil) -> Cancellable{
        return Api.request(.api(.userJsmithTweets, [:])) { (res) in
            if let _res = res as? Array<Any>, let tws = TimeLineTweets.deserialize(from: ["tweets": _res]){
                completion?(tws)
            }
        }
    }
    
    @discardableResult
    public static func getSender(_ completion:((TimeLineTweet.TimeLineSender)->())? = nil) -> Cancellable{
        return Api.request(.api(.userJsmith, [:])) { (res) in
            if let _res = res as? Dictionary<String, Any>, let sender = TimeLineTweet.TimeLineSender.deserialize(from: _res){
                completion?(sender)
            }
        }
    }
}



public class TimeLineTweet: CElement{
    
    var content = ""
    var images: Array<TimeLineImage> = []
    var comments: Array<TimeLineComment> = []
    var sender = TimeLineSender()
    
    public class TimeLineImage: CElement{
        var url = ""
    }
    
    public class TimeLineSender: CElement{
        var username = ""
        var nick = ""
        var avatar = ""
        var profileImage = ""
        
        public override func mapping(mapper: HelpingMapper) {
            mapper.specify(property: &profileImage, name: "profile-image")
        }
    }
    
    public class TimeLineComment: CElement{
        var content = ""
        var sender = TimeLineSender()
    }
    
    
    
}



