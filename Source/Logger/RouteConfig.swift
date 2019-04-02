//
//  RouteConfig.swift
//  Logger
//
//  Created by 张行 on 2019/3/8.
//

import Foundation
import PerfectHTTPServer
import PerfectHTTP

protocol LoadRoutesProtocol {
   static func loadRoutes()
}

struct V1 {
    static var routes:Routes = Routes()
}

class RouteConfig {
    static func loadRoutes(server:HTTPServer) {
        API.loadRoutes()
        WEB.loadRoutes()
        server.addRoutes(V1.routes)
    }
    class API {
        
    }
    class WEB {
        
    }
}

extension RouteConfig.WEB:LoadRoutesProtocol {
    static func loadRoutes() {
        Index.loadRoutes()
    }
}

extension RouteConfig.API:LoadRoutesProtocol {
    static func loadRoutes() {
        LoggerInfo.loadRoutes()
        MD5Verify.loadRoutes()
        UploadFile.loadRoutes()
    }
}

extension HTTPResponse {
    func completionServerErrorCode(errorCode:ServerErrorCode) {
        let responseData:[String:Any] = [
            "state":errorCode.localizedDescription.errorCode(),
            "message":errorCode.localizedDescription
        ]
        let _ = try? self.setBody(json: responseData)
        self.addHeader(HTTPResponseHeader.Name.accessControlAllowOrigin, value: "*")
        self.completed()
    }
    func completionSuccess(data:Any, message:String = "请求成功") {
        let _ = try? self.setBody(json:[
            "state":200,
            "message":message,
            "data":data
            ])
//        print("➡️\(data)")
        self.addHeader(HTTPResponseHeader.Name.accessControlAllowOrigin, value: "*")
        self.completed()
    }
}
