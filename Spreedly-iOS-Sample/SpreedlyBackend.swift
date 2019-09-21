//
//  SpreedlyBackend.swift
//  Spreedly-iOS-Sample
//
//  Created by Jeremy Rowe on 8/20/19.
//  Copyright © 2019 Spreedly. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpreedlyBackend {
    
    static let envKey = environmentKey
    static let envSecret = environmentSecret
    
    static func purchase_continue(transactionToken: String, threeDSData: String, continueCompletion: @escaping (JSON) -> Void) {
        let url = "\(baseURL)/transactions/\(transactionToken)/continue.json"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "three_ds_data": "\(threeDSData)"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .authenticate(user: envKey, password: envSecret)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    continueCompletion(json)
                case .failure(let error):
                    print("Purchase Continue Error: \(error)")
                }
        }
    }
    
    static func purchase(amount: Int, card: [String: String], options: [String: String], purchaseCompletion: @escaping (JSON) -> Void) {
        let url = "\(baseURL)/gateways/\(options["gatewayToken"]!)/purchase.json"

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        var parameters = [
            "transaction": [
                "credit_card": [
                    "full_name": "Jane Doe",
                    "number": "\(card["number"]!)",
                    "verification_value": "\(card["verificationValue"]!)",
                    "month": "\(card["month"]!)",
                    "year": "\(card["year"]!)"
                ],
                "amount": amount,
                "currency_code": "USD"
            ]
        ]
        
        if options["attempt3DSecure"]! == "true" {
            parameters["transaction"]?["attempt_3dsecure"] = true
            parameters["transaction"]?["three_ds_version"] = "2"
            parameters["transaction"]?["channel"] = "app"
            parameters["transaction"]?["callback_url"] = "https://example.com/callback"
            parameters["transaction"]?["redirect_url"] = "shirts://redirect"
        }

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .authenticate(user: envKey, password: envSecret)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    purchaseCompletion(json)
                case .failure(let error):
                    print("Purchase Error: \(error)")
                    print(error)
                }
            }
    }
}
