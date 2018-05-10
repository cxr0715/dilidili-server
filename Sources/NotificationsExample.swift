//
//  NotificationsExample.swift
//  dilidili-server
//
//  Created by YYInc on 2018/5/9.
//

import Foundation
import PerfectNotifications
import PerfectMySQL

class NotificationsExample {
    var deviceIds = [String]()
    
    static let shareInstance = NotificationsExample()
    
    private init(){}
    
    func receiveDeviceId(deviceid:String) {
        if !deviceIds.contains(deviceid) {
            let notificationValues = "'\(deviceid)'"
            let notificationStatement = "insert into notification (devicedid) select \(notificationValues) from dual where not exists (select * from notification where notification.devicedid = \(notificationValues))"
            let isNotificationSuccess = MySQLManager.shareInstance.mysql.query(statement: notificationStatement)
            if isNotificationSuccess {
                print("insertNotificationSuccess")
            } else {
                print("insertNotificationError")
            }
            deviceIds.append(deviceid)
        }
    }
    
    func sendNotification() -> String {
        print("Sending notification to devices:\(deviceIds)")
        let statement = "select devicedid from notification"
        let isSendSelect = MySQLManager.shareInstance.mysql.query(statement: statement)
        if isSendSelect {
            print("SendSelectSuccess")
            let result = MySQLManager.shareInstance.mysql.storeResults()!
            var array = [String]()
            result.forEachRow { row in
                var stringDevicedid = String()
                stringDevicedid = "\(row[0]!)"
                array.append(stringDevicedid)
            }
            for i in 0..<array.count {
                NotificationPusher(apnsTopic: notificationsTestId)
                    .pushAPNS(configurationName: notificationsTestId, deviceTokens: [array[i]], notificationItems: [.alertBody("Hello!"),.sound("default")]) { (responses) in
                        print("\(responses)")
                }
            }
        }
        return "success"
    }
}
