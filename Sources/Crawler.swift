//
//  Crawler.swift
//  dilidili-server
//
//  Created by YYInc on 2018/4/21.
//

import Foundation
import PerfectCURL
import PerfectXML

class Crawler: NSObject {
    static func requestData() {
        let url = "http://www.dilidili.wang/watch3/61940/"
        do {
            let resultHTML : String = try CURLRequest(url).perform().bodyString
            extendHTML(html: resultHTML)
        } catch {
            print("ERROR")
        }
    }
    static func extendHTML(html:String) {
        print(html)
    }
}
