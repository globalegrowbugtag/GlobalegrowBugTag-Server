//
//  UploadFile.swift
//  Logger
//
//  Created by 张行 on 2019/3/8.
//

import Foundation
import PerfectLib
import CryptoSwift
import PerfectHTTP

extension RouteConfig.API {
    class UploadFile:LoadRoutesProtocol {
        static func loadRoutes() {
            uploadFile()
        }
        static func uploadFile() {
            V1.routes.add(method: .post, uri: "uploadFile") { (req, rep) in
                guard let uuid = req.param(name: "uuid"), uuid.count > 0 else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "uuid"))
                    return
                }
                guard let files = req.postFileUploads, files.count > 0 else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "files"))
                    return
                }
                let time = Int(Date().timeIntervalSince1970)
                let dir = self.loadDir(dir: Dir(Dir.workingDir.path + "webroot"))
                let bugsDir = self.loadDir(dir: Dir(dir.path + "bugs"))
                let uuidDir = self.loadDir(dir: Dir(bugsDir.path + uuid))
                let timeDir = self.loadDir(dir: Dir(uuidDir.path + String(time)))
                var data:[[String:Any]] = []
                for fileInfo in files {
                    guard fileInfo.fileName.count > 0 else {
                        continue
                    }
                    let file = File(fileInfo.tmpFileName)
                    let dataBytes = try? file.readSomeBytes(count: file.size)
                    let md5 = dataBytes?.md5().toHexString()
                    let movePath = timeDir.path + fileInfo.fileName
                    let filePath = movePath.replacingOccurrences(of: Dir.workingDir.path, with: "")
                    do {
                        let _ = try file.moveTo(path: movePath, overWrite: true)
                        data.append([
                            "fileName":fileInfo.fileName,
                            "isSuccess":true,
                            "filePath":filePath
                            ])
                        if let _md5 = md5 {
                            try? MD5FileDB().saveFileMD5(md5: _md5, filePath: filePath)
                        }
                    } catch {
                        data.append([
                            "fileName":fileInfo.fileName,
                            "isSuccess":false,
                            "message":error.localizedDescription
                            ])
                    }
                }
                
                rep.completionSuccess(data: data)
            }
        }
        
        static func loadDir(dir:Dir) -> Dir {
            guard !dir.exists else {
                return dir
            }
            try? dir.create()
            return dir
        }
        
    }
}
