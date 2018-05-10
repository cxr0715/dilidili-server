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
    func requestData(url:String) -> String {
        var resultHTML:String = ""
        do {
            resultHTML = try CURLRequest(url).perform().bodyString
            let animeID = 11
            let animeTitle = self.getAnimeTitle(html: resultHTML as NSString)
            let animeImage = self.getAnimeImage(html: resultHTML as NSString)
            let resultObject = self.extendHTML(html: resultHTML)
            let DBresult = MySQLOperation().insertToDataBase(animeID: animeID, animeTitle: animeTitle, animeImage: animeImage, vidoeURLArray: resultObject.vidoeURLArray, titleArray: resultObject.titleArray, indexArray: resultObject.indexArray)
            if DBresult {
                print("insertSuccess")
            }
        } catch {
            print("ERROR")
        }
        return resultHTML
    }
    
    /// 获取每一集的播放地址
    ///
    /// - Parameter videoURL: D站网址
    /// - Returns: 播放地址
    func videoURL(videoURL:NSString) -> String {
        let index:Int = videoURL.range(of: ".mp4").location
        if index != NSNotFound {
            let subString:NSString = videoURL.substring(to: index+4) as NSString
            let start:Int = subString.range(of: "http", options: .backwards).location
            var range = NSRange()
            range.location = start
            range.length = index - start + 4
            let finish = subString.substring(with: range)
            return finish
        } else {
            return "NotFound"
        }
    }
    
    /// 获取animate封面
    ///
    /// - Parameter html: D站网址
    /// - Returns: 封面image
    func getAnimeImage(html:NSString) -> String {
        let index:Int = html.range(of: "<div class=\"con24 player_img\"><img src=\"").location
        if index != NSNotFound {
            let subString:NSString = html.substring(from: index + 40) as NSString
            let end:Int = subString.range(of: "\" /></div>").location
            let finish = subString.substring(to: end)
            return finish
        } else {
            return "ImageNotFound"
        }
    }
    
    /// 获取animate标题
    ///
    /// - Parameter html: D站网址
    /// - Returns: animate标题
    func getAnimeTitle(html:NSString) -> String {
        let index:Int = html.range(of: "<meta name=\"keywords\" content=\"").location
        if index != NSNotFound {
            let subString:NSString = html.substring(from: index + 31) as NSString
            let end:Int = subString.range(of: "\" />\r\n").location
            let finish = subString.substring(to: end)
            return finish
        } else {
            return "TitleNotFound"
        }
    }
    
    /// Crawler
    ///
    /// - Parameter html: D站网址
    func extendHTML(html:String) -> (vidoeURLArray:Array<String>, titleArray:Array<String>, indexArray:Array<String>) {
        var nextVideoArray : Array<String> = Array()
        var titleArray : Array<String> = Array()
        var indexArray : Array<String> = Array()
        
        let xDoc = HTMLDocument(fromSource: html)
        for item in (xDoc?.getElementsByTagName("div"))! {
            let itemAtt = item.getAttribute(name: "class")
            if itemAtt == "num con24 clear" {
                var nextVideo : String = ""
                var title : String = ""
                var index : String = ""
                
                let childNodes = item.childNodes
                for childItem in childNodes {
                    if childItem.nodeName == "a" {
                        nextVideo = (childItem.attributes?.getNamedItem(name: "href")?.nodeValue)!
                        title = (childItem.attributes?.getNamedItem(name: "title")?.nodeValue)!
                        index = childItem.nodeValue!
                        nextVideoArray.append(nextVideo)
                        titleArray.append(title)
                        indexArray.append(index)
                    }
                }
            }
        }
        
        var vidoeURLArray:Array<String> = Array()
        for i in 0..<nextVideoArray.count {
            do {
                let resultHTML:String = try CURLRequest(nextVideoArray[i]).perform().bodyString
                let str:NSString = resultHTML as NSString
                let videoURL1 = videoURL(videoURL: str)
                if videoURL1 != "NotFound" {
                    vidoeURLArray.append(videoURL1)
                }
            } catch {
                print("ERROR")
            }
        }
        return (vidoeURLArray, titleArray, indexArray)
    }
}
