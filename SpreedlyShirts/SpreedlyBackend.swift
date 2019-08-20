//
//  SpreedlyBackend.swift
//  SpreedlyShirts
//
//  Created by Jeremy Rowe on 8/20/19.
//  Copyright © 2019 Spreedly. All rights reserved.
//

import Foundation
import SwiftyJSON

class SpreedlyBackend {
    
    static let envKey = environmentKey
    static let envSecret = environmentSecret
    
    static func purchase(amount: Int, purchaseCompletion: (JSON?, Error?)) {
        let url = URL(string: baseURL + "/gateways/\(gatewayToken)/purchase.json")

        var request = URLRequest(url: url!)
        let session = URLSession.shared
        
        let body = [
            "transaction": [
                "credit_card": [
                    "first_name": "Jon",
                    "last_name": "Doe",
                    "number": "\(threeDSCardNumber)",
                    "verification_value": "\(threeDSCVV)",
                    "month": "\(threeDSMonth)",
                    "year": "\(threeDSYear)"
                ],
                "attempt_3dsecure": true,
                "three_ds_version": "2",
                "channel": "app",
                "callback_url": "https://example.com/callback",
                "redirect_url": "https://example.com/redirect",
                "amount": 12100,
                "currency_code": "USD"
                
            ]
        ]
        
        let data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch error {
            print("Error serializing dictionary")
            purchaseCompletion(nil, error)
        }
        
        request.httpBody = data
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(basic_auth())", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                purchaseCompletion(nil, error)
            } else {
                do {
                    let response = try JSON(data: data!)
                    purchaseCompletion(response, nil)
                } catch error {
                    print("Error parsing response")
                    purchaseCompletion(nil, error)
                }
                
            }
//            if (error != nil) {
//                DispatchQueue.main.async(execute: {
//                    completion(nil, error as NSError?)
//                })
//            } else {
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                        if let transactionDict = json["transaction"] as? NSDictionary {
//                            if let paymentMethodDict = transactionDict["payment_method"] as? [String: AnyObject] {
//                                let paymentMethod = PaymentMethod(attributes: paymentMethodDict)
//                                DispatchQueue.main.async(execute: {
//                                    completion(paymentMethod, nil)
//                                })
//                            }
//                        } else {
//                            if let errors = json["errors"] as? NSArray {
//                                let error = errors[0] as! NSDictionary
//                                let userInfo = ["SpreedlyError": error["message"]!]
//                                let apiError = NSError(domain: "com.spreedly.lib", code: 60, userInfo: userInfo)
//                                DispatchQueue.main.async(execute: {
//                                    completion(nil, apiError)
//                                })
//                            }
//                        }
//                    }
//                } catch let parseError as NSError {
//                    DispatchQueue.main.async(execute: {
//                        completion(nil, parseError)
//                    })
//                }
//            }
        })
        
        task.resume()
        
        return nil
    }
    
    private static func basic_auth() -> String {
        let creds = "\(envKey):\(envSecret)"
        return Data(creds.utf8).base64EncodedString()
    }
}
