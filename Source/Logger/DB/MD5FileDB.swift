//
//  MD5FileDB.swift
//  Logger
//
//  Created by 张行 on 2019/3/11.
//

import Foundation
import PerfectCRUD

class MD5FileDB: DB {
    func findFileMD5(md5:String) throws -> FileMD5? {
        let db = try loadDB()
        let fileMD5Table = db.table(FileMD5.self)
        let query = fileMD5Table.where(\FileMD5.fileMD5 == md5)
        let fileMD5 = try query.first()
        return fileMD5
    }
    func saveFileMD5(md5:String, filePath:String) throws {
        let db = try loadDB()
        let table = db.table(FileMD5.self)
        let fileMD5 = FileMD5.init(id: 0, fileMD5: md5, filePath: filePath)
        try table.insert(fileMD5)
    }
}
