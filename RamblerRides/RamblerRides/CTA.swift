//
//  CTA.swift
//  RamblerRides
//
//  Created by Tyler Bobella on 11/14/15.
//  Copyright © 2015 LUCCS. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

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
    func getTrain(campus: String, completionHandler: (NSDictionary?, ErrorType?) -> ()) {
        if campus == "lakeshore" {
            lscTrainPromises(completionHandler)
        } else if campus == "watertower" {
            wtcTrainPromises(completionHandler)
        }
    }
    
    private func lscInboundTrain() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaLSCRInbound)").response { (request, response, data, error) in
                if error == nil {
                    let parser = NSXMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    fulfill(self.parsedDictionary)
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    private func lscOutboundTrain() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaLSCROutbound)").response { (request, response, data, error) in
                if error == nil {
                    let parser = NSXMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    fulfill(self.parsedDictionary)
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    private func lscTrainPromises(completionHandler: (NSDictionary?, ErrorType?) -> ()) -> () {
        var lscDictionary = [String: AnyObject]()

        firstly {
            return lscInboundTrain()
            }.then { (inbound: AnyObject) in
                lscDictionary["InboundTrain"] = inbound
                return self.lscOutboundTrain()
            }.then{ (outbound: AnyObject) -> Void in
                lscDictionary["OutboundTrain"] = outbound
                completionHandler(lscDictionary, nil)
            }.error { error in
                completionHandler(nil, error)
        }
    }
    
    private func wtcInboundTrain() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaWTCInbound)").response { (request, response, data, error) in
                if error == nil {
                    let parser = NSXMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    fulfill(self.parsedDictionary)
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    private func wtcOutboundTrain() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            Alamofire.request(.GET, "\(baseTrainUrl)&stpid=\(loyolaWTCOutbound)").response { (request, response, data, error) in
                if error == nil {
                    let parser = NSXMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    fulfill(self.parsedDictionary)
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    private func wtcTrainPromises(completionHandler: (NSDictionary?, ErrorType?) -> ()) -> () {
        var wtcDictionary = [String: AnyObject]()
        
        firstly {
            return wtcInboundTrain()
            }.then { (inbound: AnyObject) in
                wtcDictionary["InboundTrain"] = inbound
                return self.wtcOutboundTrain()
            }.then{ (outbound: AnyObject) -> Void in
                wtcDictionary["OutboundTrain"] = outbound
                completionHandler(wtcDictionary, nil)
            }.error { error in
                completionHandler(nil, error)
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