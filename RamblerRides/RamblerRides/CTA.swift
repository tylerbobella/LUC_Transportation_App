//
//  CTA.swift
//  RamblerRides
//
//  Created by Tyler Bobella on 11/14/15.
//  Copyright © 2015 LUCCS. All rights reserved.
//

import Foundation
import Alamofire

class CTA: NSObject, NSXMLParserDelegate {

    let trainApiKey = "YOUR_API_KEY_HERE"
    let loyolaLSCRInbound = "30252"
    let loyolaLSCROutbound = "30251"
    let loyolaWTCInbound = "30279"
    let loyolaWTCOutbound = "30280"
    var baseTrainUrl = String()
    var baseBusUrl = String()
    private var parsedDictionary = [String: String]()
    private var lastParsed = String()
    
    override init() {
        baseTrainUrl = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=\(trainApiKey)"
        baseBusUrl = "http://www.ctabustracker.com/bustime/api/v1/gettime?"
    }
    
    // Have to handle async call properly
    func getTrain(campus: String, completionHandler: (NSDictionary?, NSError?) -> ()) {
        trainData(campus, completionHandler: completionHandler)
    }
    
    private func trainData(campus: String, completionHandler: (NSDictionary?, NSError?) -> ()) -> () {
        print("Hit method")
        if campus == "lakeshore" {
            //TODO: Refactor this!
            //Inbound times
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaLSCRInbound)").response { (request, response, data, error) in
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                completionHandler(self.parsedDictionary, error)
            }
            
            //Outbound times
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaLSCROutbound)").response { (request, response, data, error) in
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                completionHandler(self.parsedDictionary, error)
            }
            
        }
        
        if campus == "watertower" {
            //TODO: Refactor this!
            //Inbound times
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaWTCInbound)").response { (request, response, data, error) in
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                completionHandler(self.parsedDictionary, error)
            }
            
            //Outbound times
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaWTCOutbound)").response { (request, response, data, error) in
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                completionHandler(self.parsedDictionary, error)
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        lastParsed = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        parsedDictionary[lastParsed] = string
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("elementName:  \(elementName)")
        parsedDictionary[elementName] = lastParsed
    }
}