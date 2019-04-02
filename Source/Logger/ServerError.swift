//
//  ServerError.swift
//  Logger
//
//  Created by 张行 on 2019/3/8.
//

import Foundation

enum ServerErrorCode {
    case systemError(error:String)
    case notExit(name:String)
}

extension ServerErrorCode : LocalizedError {
    var localizedDescription: String {
        switch self {
        case .systemError(let error):
            return "系统报错:\(error)"
        case .notExit(let name):
            return "\(name) 值不存在"
            
        }
    }
}
var errorCodeStart = 1000
var errorCodeMap:[String:Int] = [:]
extension String {
    func errorCode() -> Int {
        guard let code = errorCodeMap[self] else {
            errorCodeStart += 1
            errorCodeMap[self] = errorCodeStart
            return errorCodeStart
        }
        return code;
    }
}

