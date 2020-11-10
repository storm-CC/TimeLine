//
//  Api.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/21.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import Moya
import Result



open class ApiRequest: MoyaProvider<Api> {
    static public let shared = ApiRequest()
    
}


public enum Api {
    case api(TimeLineApi, [String: Any])
    
    static func request(_ api: Api, completion:((_ rs: Any?) -> ())?) -> Cancellable{
       return ApiRequest.shared.request(api) { (result) in
            //此处可以对返回数据做统一处理再回传。
            //简陋处理，
            if case let .success(response) = result{
                do{
                    let _data = try JSONSerialization.jsonObject(with: response.data, options: [.mutableContainers])
                        completion?(_data)
                }catch{
                }
                
                print(" headers:\(api.headers ?? [:])\n path:\(api.path)\n statusCode:\(response.statusCode)")
            }
            else if case let .failure(error) = result {
                print(error.localizedDescription)
                completion?(nil)
            }
            
            
        }
    }
}



extension Api: TargetType {
    
    public var baseURL: URL{
        switch self {
        case .api:
            return URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!
        }
        
    }
    
    public var path: String{
        switch self {
        case .api(let path, let value):
            return path.subpath(value)
        }
    }
    
    public var task: Task {
        switch self {
        case .api(_, let value):
            return .requestParameters(parameters: value, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    //单元测试模拟数据。
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
