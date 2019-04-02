//
//  MD5Verify.swift
//  Logger
//
//  Created by 张行 on 2019/3/11.
//

import Foundation
import PerfectLib
import PerfectHTTP

extension RouteConfig.API {
    class MD5Verify:LoadRoutesProtocol {
        static func loadRoutes() {
            verify()
        }
        static func verify() {
            V1.routes.add(method: .post, uri: "md5Verify") { (req, rep) in
                let md5s = req.params(named: "md5s[]")
                guard md5s.count > 0 else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "md5s"))
                    return
                }
                var data:[[String:Any]] = []
                for md5 in md5s {
                    let db = MD5FileDB()
                    let fileMD5 = try? db.findFileMD5(md5: md5)
                    if let _fileMD5 = fileMD5, let __fileMD5 = _fileMD5 {
                        data.append([
                            "md5":md5,
                            "isUpload":true,
                            "filePath":__fileMD5.filePath
                            ])
                    } else {
                        data.append([
                            "md5":md5,
                            "isUpload":false,
                            ])
                    }
                }
                rep.completionSuccess(data: data)
            }
        }
    }
    
}
