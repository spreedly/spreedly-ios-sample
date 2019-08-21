//
//  SpreedlyBackend.swift
//  SpreedlyShirts
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
    
    static func purchase(amount: Int) { //purchaseCompletion: (JSON?, Error?)) {
        let url = "\(baseURL)/gateways/\(gatewayToken)/purchase.json"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters = [
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
                "amount": amount,
                "currency_code": "USD"
                
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .authenticate(user: envKey, password: envSecret)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                case .failure(let error):
                    print(error)
                }
            }
    }
}
