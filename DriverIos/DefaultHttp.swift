//
//  File.swift
//  HeadlinesNews
//
//  Created by weiming on 2016/11/25.
//  Copyright © 2016年 weiming. All rights reserved.
//

import Foundation
import Alamofire

//let httpurl = "http://192.168.1.248:8082/liner-client/liner/android"
let httpurl = "http://apitest.yunba.com:20082/service_client/open/cargoapp"
class DefaultHttp{
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    func httopost(parame:Dictionary<String,Any>,call:@escaping (_ results:([String:Any]))->Void){
        let parameters: Parameters = parame
        print("请求参数：\(parameters)")
        
        Alamofire.request(httpurl,method: .post,parameters:parameters).validate().responseJSON{ response in
            switch response.result {
            case .success:
            
            if let JSON = response.result.value{
                let str = JSON as! [String:Any]
                call(str)
//                print("JSON: \(str["resultInfo"] as! String)")
                }
//            comple(json,error)
                break
            case .failure( _): break
                //失败的操作
                //调用completion(json,error)
            }
        }
    }
}
