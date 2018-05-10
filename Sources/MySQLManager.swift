//
//  MySQLManager.swift
//  COpenSSL
//
//  Created by YYInc on 2018/4/23.
//

import Foundation
import PerfectMySQL

class MySQLManager {
    var mysql : MySQL!
    static let shareInstance : MySQLManager = {
        let instance = MySQLManager()
        let testHost = "127.0.0.1"
        let testUser = "root"
        let testPassword = "dw123456"
        let testDB = "dilidili"
        instance.mysql = MySQL()
        let connected = instance.mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)

        if connected {
            print("connectedSuccess")
        } else {
            print("connectedError")
        }

        guard connected else {
            // 验证一下连接是否成功
            print(instance.mysql.errorMessage())
            return instance
        }
        return instance
    }()
    private init(){}
//    func connected() -> MySQL {
////        if mysql == nil {
//            let testHost = "127.0.0.1"
//            let testUser = "root"
//            let testPassword = "dw123456"
//            let testDB = "dilidili"
//            mysql = MySQL()
//            let connected = mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
//
//            if connected {
//                print("connectedSuccess")
//            } else {
//                print("connectedError")
//            }
//
//            guard connected else {
//                // 验证一下连接是否成功
//                print(mysql.errorMessage())
//                return mysql
//            }
////        }
//        return mysql
//    }

}



