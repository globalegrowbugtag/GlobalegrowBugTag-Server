//
//  FileMD5.swift
//  Logger
//
//  Created by 张行 on 2019/3/11.
//

import Foundation
import PerfectMySQL

struct FileMD5: Codable {
    let id:Int
    let fileMD5:String
    let filePath:String
}

