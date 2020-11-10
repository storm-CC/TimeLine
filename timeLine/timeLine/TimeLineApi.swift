//
//  TimeLineApi.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/21.
//  Copyright © 2020 stormVCC. All rights reserved.
//



public enum TimeLineApi{
    case userJsmith
    case userJsmithTweets
    
    public func subpath(_ value: [String: Any]) -> String{
        switch self {
        case .userJsmith:
            return "/user/jsmith"
        case .userJsmithTweets:
            return "/user/jsmith/tweets"
        }
    }
}
