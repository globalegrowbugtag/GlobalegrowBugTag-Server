//
//  LoggerInfoDB.swift
//  Logger
//
//  Created by 张行 on 2019/3/12.
//

import Foundation
import PerfectCRUD

class LoggerInfoDB: DB {
    var count:Int = 0
    func saveLoggerInfo(uuid:String, loggerJson:String, isCrash:String = "0") throws {
        let db = try loadDB()
        let table = db.table(LoggerInfo.self)
        let loggerInfo = LoggerInfo(id:0,uuid: uuid, isCrash: isCrash ,loggerJson: loggerJson, solve:0, platform:"iOS")
        try table.insert(loggerInfo)
    }
    
    func findLoggerList(start:Int, count:Int, type:String = "0") throws -> [LoggerInfo] {
        let db = try loadDB()
        let table = db.table(LoggerInfo.self)
        self.count = try table.count()
        var loggerLists:[LoggerInfo] = []
        if type == "0" || type == "3" {
            let solve = type == "0" ? 0 : 1
            let countQuery = table.where(\LoggerInfo.solve == solve)
            let query = table.limit(count, skip: start).where(\LoggerInfo.solve == solve)
            self.count = try countQuery.count()
            let list = try query.select()
            for logger in list {
                loggerLists.append(logger)
            }
        } else {
            let isCrash = type == "1" ? "1" : "0"
            let countQuery = table.where(\LoggerInfo.isCrash == isCrash && \LoggerInfo.solve == 0)
            self.count = try countQuery.count()
            let query = table.limit(count, skip: start).where(\LoggerInfo.isCrash == isCrash && \LoggerInfo.solve == 0)
            let list = try query.select()
            for logger in list {
                loggerLists.append(logger)
            }
        }

        return loggerLists
    }
    
    func findLogger(id:Int) throws -> LoggerInfo? {
        let db = try loadDB()
        let table = db.table(LoggerInfo.self)
        let query = try table.where(\LoggerInfo.id == id).select()
        return query.first(where: { (loggerInfo) -> Bool in
            return true
        })
    }
    
    func updateLogger(logger:LoggerInfo) throws {
        let db = try loadDB()
        let table = db.table(LoggerInfo.self)
        try table.where(\LoggerInfo.id == logger.id).update(logger, setKeys:\LoggerInfo.solve)
    }
}
