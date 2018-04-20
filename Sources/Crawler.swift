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
    static func requestData() -> String {
        let url = "http://www.dilidili.wang/watch3/61940/"
        var resultHTML:String = ""
        do {
            resultHTML = try CURLRequest(url).perform().bodyString
            extendHTML(html: resultHTML)
        } catch {
            print("ERROR")
        }
        return resultHTML
    }
    static func extendHTML(html:String) {
        let xDoc = HTMLDocument(fromSource: html)
        print(xDoc)
    }
}
