//
//  index.swift
//  Logger
//
//  Created by 张行 on 2019/3/15.
//

import Foundation
import PerfectMustache
import PerfectLib
import PerfectHTTP

extension RouteConfig.WEB {
    class Index: LoadRoutesProtocol {
        
        static func loadRoutes() {
            webIndex()
        }
        static func webIndex() {
            V1.routes.add(method: .get, uri: "/") { (req, rep) in
                guard let countString = req.param(name: "count", defaultValue: "20"), let count = Int(countString) else {
                    responseIndex(source: [:], rep: rep)
                    return
                }
                guard let startString = req.param(name: "index", defaultValue: "0"), let start = Int(startString) else {
                    responseIndex(source: [:], rep: rep)
                    return
                }
                do {
                    let db = LoggerInfoDB()
                    let loggerList = try db.findLoggerList(start: start, count: count)
                    var source:[String:Any] = [
                        "up" : start > 0,
                        "down" : (start * count) >= db.count
                    ]
                    var list:[[String:Any]] = []
                    for logger in loggerList {
                        guard let data = logger.loggerJson.data(using: String.Encoding.utf8) else {
                            continue
                        }
                        
                        guard let loggerJson = try? JSONDecoder().decode(LoggerJson.self, from: data) else {
                            continue
                        }
                        list.append([
                            "imageURL" : loggerJson.screenImagePath.replacingOccurrences(of: "webroot/", with: ""),
                            "note" : loggerJson.note
                            ])
                    }
                    source["list"] = list
                    responseIndex(source: source, rep: rep)
                    
                } catch {
                    responseIndex(source: [:], rep: rep)
                }
            }
        }
        
        static func responseIndex(source:[String:Any], rep:HTTPResponse) {
            let indexMustacheFile = File(Dir.workingDir.path + server.documentRoot + "/index.mustache")
            let context = MustacheEvaluationContext(templatePath: indexMustacheFile.path, map: source)
            let content = try? context.formulateResponse(withCollector: MustacheEvaluationOutputCollector())
            rep.setHeader(HTTPResponseHeader.Name.contentType, value: "text/html")
            let _ = rep.setBody(string: content ?? ServerErrorCode.systemError(error: "获取 Index.mustache内容失败").localizedDescription)
            rep.completed()
        }
    }
}

