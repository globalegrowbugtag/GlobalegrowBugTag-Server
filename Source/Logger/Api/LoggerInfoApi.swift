//
//  LoggerInfoApi.swift
//  Logger
//
//  Created by 张行 on 2019/3/12.
//

import Foundation
import PerfectLib
import PerfectHTTP

extension RouteConfig.API {
    struct LoggerInfo:LoadRoutesProtocol {
        static func loadRoutes() {
            saveLogger()
            getLoggerInfoList()
            getLoggerInfo()
            updateLoggerInfo()
        }
        static func saveLogger() {
            V1.routes.add(method: .post, uri: "loggerInfo") { (req, rep) in
                guard let uuid = req.param(name: "uuid") else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "uuid"))
                    return
                }
                guard let loggerJson = req.param(name: "LoggerJson") else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "LoggerJson"))
                    return
                }
                guard let isCrash = req.param(name: "isCrash")  else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "isCrash"))
                    return
                }
                do {
                    try LoggerInfoDB().saveLoggerInfo(uuid: uuid, loggerJson: loggerJson, isCrash: isCrash)
                    rep.completionSuccess(data: [:])
                } catch {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.systemError(error: error.localizedDescription))
                }
            }
        }
        
        static func getLoggerInfoList() {
            V1.routes.add(method: .get, uri: "loggerInfoList") { (req, rep) in
                guard let countString = req.param(name: "count", defaultValue: "20"), let count = Int(countString) else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "count"))
                    return
                }
                guard let pageString = req.param(name: "page", defaultValue: "0"), let page = Int(pageString) else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "page"))
                    return
                }
                guard let type = req.param(name: "type", defaultValue: "0") else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "page"))
                    return
                }
                do {
                    let start = (page - 1) * count
                    let db = LoggerInfoDB()
                    let loggerList = try db.findLoggerList(start: start, count: count, type: type)
                    var list:[[String:Any]] = []
                    for logger in loggerList {
                        if let jsonDic = try? logger.toJsonObject() {
                            list.append(jsonDic)
                        }
                    }
                    rep.completionSuccess(data: [
                        "count":db.count,
                        "list":list
                        ])
                } catch {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.systemError(error: error.localizedDescription))
                }
            }
        }
        static func getLoggerInfo() {
            V1.routes.add(method: .get, uri: "loggerInfo") { (req, rep) in
                guard let idString = req.param(name: "id"), let id = Int(idString) else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "id"))
                    return
                }
                do {
                   let db = LoggerInfoDB()
                   let loggerInfo = try db.findLogger(id: id)
                    var data:[String:Any] = [:]
                    if let logger = loggerInfo, let jsonDic = try? logger.toJsonObject() {
                        data = jsonDic
                    }
                    rep.completionSuccess(data: data)
                } catch {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.systemError(error: error.localizedDescription))
                }
            }
        }
        static func updateLoggerInfo() {
            V1.routes.add(method: .post, uri: "updateLoggerInfo") { (req, rep) in
                guard let idString = req.param(name: "id"), let id = Int(idString) else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "id"))
                    return
                }
                guard let solve = req.param(name: "solve"), let solveInt = Int(solve) else {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.notExit(name: "solve"))
                    return
                }
                do {
                    let db = LoggerInfoDB()
                    let loggerInfo = try db.findLogger(id: id)
                    if var loggerInfo = loggerInfo {
                        loggerInfo.solve = solveInt
                        try db.updateLogger(logger: loggerInfo)
                    }
                    rep.completionSuccess(data: [:])
                } catch {
                    rep.completionServerErrorCode(errorCode: ServerErrorCode.systemError(error: error.localizedDescription))
                }
            }
        }
    }
}
