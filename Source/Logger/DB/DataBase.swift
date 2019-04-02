//
//  DataBase.swift
//  Logger
//
//  Created by 张行 on 2019/3/11.
//

import Foundation
import PerfectMySQL
import PerfectCRUD

class DB {
    func loadDB() throws -> Database<MySQLDatabaseConfiguration> {
        let configuration = try MySQLDatabaseConfiguration(database: "Logger", host: "localhost", port: 3306, username: "root", password: "")
        let db = Database(configuration: configuration)
        return db
    }
    func createTable() throws {
        let db = try loadDB()
        try db.create(FileMD5.self, policy: .shallow)
        try db.create(LoggerInfo.self, policy: .shallow)
    }
}
