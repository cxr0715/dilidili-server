//
//  MySQLManager.swift
//  COpenSSL
//
//  Created by YYInc on 2018/4/23.
//

import Foundation
import PerfectMySQL

class MySQLManager {
    let testHost = "127.0.0.1"
    let testUser = "root"
    let testPassword = "123456"
    let testDB = "dilidili"
    var mysql : MySQL!
    static let shareInstance = MySQLManager.init()
    private init() {
        if mysql == nil {
            mysql = MySQL()
            let connected = mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
            
            if connected {
                print("connectedSuccess")
            } else {
                print("connectedError")
            }
            
            guard connected else {
                // 验证一下连接是否成功
                print(mysql.errorMessage())
                return
            }
        }
    }

}



