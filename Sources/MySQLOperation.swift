//
//  MySQLOperation.swift
//  COpenSSL
//
//  Created by YYInc on 2018/4/24.
//

import Foundation
import PerfectMySQL

let RequestResultSuccess: String = "SUCCESS"
let RequestResultFaile: String = "FAILE"
let ResultListKey = "list"
let ResultKey = "result"
let ErrorMessageKey = "errorMessage"
var BaseResponseJson: [String : Any] = [ResultListKey:[], ResultKey:RequestResultSuccess, ErrorMessageKey:""]

class MySQLOperation {
    
    /// 获取mysql单例
    var responseJson: [String : Any] = BaseResponseJson
    var mysql : MySQL {
        get {
            return MySQLManager.shareInstance.mysql
        }
    }
    
    
    /// 插入数据到home表
    ///
    /// - Parameters:
    ///   - animeID: 动画id
    ///   - animeTitle: 动画标题
    ///   - animeImage: 动画封面图片地址
    ///   - vidoeURLArray: 动画每集播放地址
    ///   - titleArray: 动画每集标题
    ///   - indexArray: 动画每集集数
    /// - Returns: 插入数据是否成功
    func insertToDataBase(animeID:Int, animeTitle:String, animeImage:String, vidoeURLArray:Array<String>, titleArray:Array<String>, indexArray:Array<String>) -> Bool {
        let homeValues = "(\(animeID), '\(animeTitle)', '\(animeImage)')"
        let homeStatement = "insert into home (id, animateTitle, animateImage) values \(homeValues)"
        let isHomeSuccess = self.mysql.query(statement: homeStatement)
        if isHomeSuccess {
            print("insertHomeSuccess")
        } else {
            print("insertHomeError")
        }
        
        let headEmpty = indexArray.count - vidoeURLArray.count
        for i in 0..<indexArray.count {
            if i < indexArray.count - 1 && i < vidoeURLArray.count && i < titleArray.count && i < indexArray.count {
                let videoValues = "(\(animeID), '\(vidoeURLArray[i])', '\(titleArray[i+headEmpty])', '\(indexArray[i+headEmpty])')"
                let videoStatement = "insert into video (animateID, animateURL, animateName, animateIndex) values \(videoValues)"
                let isVideoSuccess = self.mysql.query(statement: videoStatement)
                if isVideoSuccess {
                    print("insertVideoSuccess")
                } else {
                    print("insertVideoError")
                }
            }
        }
        return isHomeSuccess
    }
    
    
    /// 查询home表
    ///
    /// - Returns: 返回查询json结果
    func selectHomeTabelData() -> String? {
        let statement = "select * from home"
        let isHomeSelectSuccess = self.mysql.query(statement: statement)
        if isHomeSelectSuccess {
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            var array = [[String:String]]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let id = row.first! else {//保存选项表的id名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                var dic = [String:String]() //创建一个字典数于存储结果
                dic["id"] = "\(id)"
                dic["animateTitle"] = "\(row[1]!)"
                dic["animateImage"] = "\(row[2]!)"
                array.append(dic)
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = array
        } else {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
        }
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 查询video的每集信息
    ///
    /// - Parameter animateID: 动画id
    /// - Returns: 返回查询json结果
    func selectVideoTabelData(animateID:String) -> String? {
        let videoValues = "('\(animateID)')"
        let statement = "select * from video where animateID=\(videoValues)"
        let isVideoSelect = self.mysql.query(statement: statement)
        if isVideoSelect {
            print("VideoSelectSuccess")
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            var array = [[String:String]]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                var dic = [String:String]() //创建一个字典数于存储结果
                dic["animateID"] = "\(row[1]!)"
                dic["animateURL"] = "\(row[2]!)"
                dic["animateName"] = "\(row[3]!)"
                dic["animateIndex"] = "\(row[4]!)"
                array.append(dic)
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = array
        } else {
            print("VideoSelectError")
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
        }
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
}
