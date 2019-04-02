//
//  LoggerInfo.swift
//  Logger
//
//  Created by 张行 on 2019/3/12.
//

import Foundation
import PerfectMySQL
import PerfectLib

struct LoggerInfo: Codable {
    let id:Int
    let uuid:String
    let isCrash:String
    let loggerJson:String
    var solve:Int
    let platform:String
}

extension LoggerInfo {
    func toJsonObject() throws -> [String:Any] {
        let jsonData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
        guard var jsonDic = jsonObject as? [String:Any] else {
            return [:]
        }
        if let loggerData = self.loggerJson.data(using: String.Encoding.utf8), var loggerObject = try JSONSerialization.jsonObject(with: loggerData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
            if let screenImagePath = loggerObject["screenImagePath"] as? String {
                loggerObject["screenImagePath"] = screenImagePath.removeWebRoot()
            }
            if var detail = loggerObject["detail"] as? [String:Any] {
                if let logFilePath = detail["logFilePath"] as? String, let array = try? logFilePath.loggerFilePathToObject() {
                    detail["logArray"] = array
                }
                if let networkLogFilePath = detail["networkLogFilePath"] as? String, let array = try? networkLogFilePath.loggerFilePathToObject() {
                    detail["networkArray"] = array
                }
                if let operatingSetpFilePath = detail["operatingSetpFilePath"] as? String , let array = try? operatingSetpFilePath.loggerFilePathToObject() {
                    detail["operatingSetpArray"] = array
                }
                loggerObject["detail"] = detail
            }
            jsonDic["loggerInfo"] = loggerObject
        }
        return jsonDic
    }
}

extension String {
    func loggerFilePathToObject() throws -> [[String:Any]] {
        let path = Dir.workingDir.path + self
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        guard let jsonArray = jsonData as? [[String:Any]] else {
            return []
        }
        return jsonArray
    }
    func removeWebRoot() -> String {
        return self.replacingOccurrences(of: "webroot/", with: "")
    }
}


