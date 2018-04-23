//
//  MySQLOperation.swift
//  COpenSSL
//
//  Created by YYInc on 2018/4/24.
//

import Foundation
import PerfectMySQL

class MySQLOperation {
    class var mysql : MySQL {
        get {
            return MySQLManager.shareInstance.mysql
        }
    }
    
    class func insertToDataBase(animeID:Int, animeTitle:String, animeImage:String, vidoeURLArray:Array<String>, titleArray:Array<String>, indexArray:Array<String>) -> Bool {
        let homeValues = "(\(animeID), '\(animeTitle)', '\(animeImage)')"
        let homeStatement = "insert into home (id, animateTitle, animateImage) values \(homeValues)"
        let isHomeSuccess = mysql.query(statement: homeStatement)
        if isHomeSuccess {
            print("insertHomeSuccess")
        } else {
            print("insertHomeError")
        }
        
        let headEmpty = indexArray.count - vidoeURLArray.count
        for i in 0..<indexArray.count {
            if i < indexArray.count - 1 {
                let videoValues = "(\(animeID), '\(vidoeURLArray[i])', '\(titleArray[i+headEmpty])', '\(indexArray[i+headEmpty])')"
                let videoStatement = "insert into video (animateID, animateURL, animateName, animateIndex) values \(videoValues)"
                let isVideoSuccess = mysql.query(statement: videoStatement)
                if isVideoSuccess {
                    print("insertVideoSuccess")
                } else {
                    print("insertVideoError")
                }
            }
        }
        
        return isHomeSuccess
    }
}
