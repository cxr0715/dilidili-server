//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL

var resultID : String? = ""

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(request: HTTPRequest, response: HTTPResponse) {
	// Respond with a simple message.
	response.setHeader(.contentType, value: "text/html")
	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	// Ensure that response.completed() is called when your processing is done.
	response.completed()
}

func handlerCrawler(request: HTTPRequest, response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    let url = "http://www.dilidili.wang/watch3/61940/"
//    let url = "http://www.hunliji.com/community"
    response.appendBody(string: Crawler.requestData(url: url))
    response.completed()
}

func handlerHome(request: HTTPRequest, response: HTTPResponse) {
    let jsonString = MySQLOperation().selectHomeTabelData()

    response.setBody(string: jsonString!)
    response.completed()
}

func handlerVideolist(request: HTTPRequest, response: HTTPResponse) {
    guard let animateID: String = request.param(name: "animateID") else {
        print("animateID为nil")
        return
    }
    let jsonString = MySQLOperation().selectVideoTabelData(animateID: animateID)
    
    response.setBody(string: jsonString!)
    response.completed()
}

// Configuration data for an example server.
// This example configuration shows how to launch a server
// using a configuration dictionary.


let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
                ["method":"get", "uri":"/crawler", "handler":handlerCrawler],
                ["method":"get", "uri":"/home", "handler":handlerHome],
                ["method":"post", "uri":"/videolist", "handler":handlerVideolist],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

do {
    // Launch the servers based on the configuration data.
    try HTTPServer.launch(configurationData: confData)
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
