//
//  SpreedlyBackend.swift
//  Spreedly-Sample-iOS
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
    
    static func purchase(amount: Int, purchaseCompletion: @escaping (JSON) -> Void) {
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
        
//        let response = """
//        {
//            "transaction" : {
//                "challenge_url" : null,
//                "updated_at" : "2019-08-21T18:27:57Z",
//                "gateway_transaction_id" : "883566412077051E",
//                "shipping_address" : {
//                    "name" : "Jon Doe",
//                    "phone_number" : null,
//                    "address1" : null,
//                    "zip" : null,
//                    "city" : null,
//                    "state" : null,
//                    "address2" : null,
//                    "country" : null
//                },
//                "required_action" : "device_fingerprint",
//                "payment_method_added" : true,
//                "on_test_gateway" : true,
//                "ip" : null,
//                "amount" : 12100,
//                "merchant_location_descriptor" : null,
//                "response" : {
//                    "message" : "IdentifyShopper",
//                    "cvv_message" : null,
//                    "pending" : true,
//                    "cancelled" : false,
//                    "result_unknown" : false,
//                    "error_detail" : null,
//                    "avs_code" : null,
//                    "cvv_code" : null,
//                    "updated_at" : "2019-08-21T18:27:57Z",
//                    "success" : true,
//                    "error_code" : null,
//                    "fraud_review" : false,
//                    "avs_message" : null,
//                    "created_at" : "2019-08-21T18:27:57Z"
//                },
//                "order_id" : null,
//                "email" : null,
//                "succeeded" : false,
//                "payment_method" : {
//                    "payment_method_type" : "credit_card",
//                    "address1" : null,
//                    "year" : 2020,
//                    "eligible_for_card_updater" : true,
//                    "shipping_zip" : null,
//                    "city" : null,
//                    "shipping_phone_number" : null,
//                    "number" : "XXXX-XXXX-XXXX-0000",
//                    "metadata" : null,
//                    "shipping_city" : null,
//                    "data" : null,
//                    "phone_number" : null,
//                    "card_type" : "visa",
//                    "last_four_digits" : "0000",
//                    "shipping_country" : null,
//                    "first_six_digits" : "491761",
//                    "verification_value" : "XXX",
//                    "test" : false,
//                    "shipping_address2" : null,
//                    "first_name" : "Jon",
//                    "updated_at" : "2019-08-21T18:27:57Z",
//                    "callback_url" : null,
//                    "company" : null,
//                    "month" : 10,
//                    "storage_state" : "cached",
//                    "zip" : null,
//                    "fingerprint" : null,
//                    "errors" : [
//
//                    ],
//                    "created_at" : "2019-08-21T18:27:57Z",
//                    "shipping_state" : null,
//                    "state" : null,
//                    "email" : null,
//                    "last_name" : "Doe",
//                    "address2" : null,
//                    "shipping_address1" : null,
//                    "token" : "JcpkUMYytDVCHqtzAsWQqIQa8De",
//                    "full_name" : "Jon Doe",
//                    "country" : null
//                },
//                "gateway_token" : "B26HyuzA337RFQaCxXwpZ7GaPGq",
//                "setup_response" : {
//                    "message" : "IdentifyShopper",
//                    "cvv_message" : null,
//                    "pending" : true,
//                    "cancelled" : false,
//                    "result_unknown" : false,
//                    "error_detail" : null,
//                    "avs_code" : null,
//                    "cvv_code" : null,
//                    "updated_at" : "2019-08-21T18:27:57Z",
//                    "success" : true,
//                    "error_code" : null,
//                    "fraud_review" : false,
//                    "avs_message" : null,
//                    "created_at" : "2019-08-21T18:27:57Z"
//                },
//                "state" : "pending",
//                "gateway_specific_fields" : null,
//                "gateway_type" : "adyen",
//                "three_ds_context" : "eyJnYXRld2F5X3R5cGUiOiJhZHllbiIsImFkeWVuIjp7InRocmVlZHMyLnRocmVlRFMyVG9rZW4iOiJCUUFCQVFCYU81OVlpcFUvWHY3N1N1QnJ5ZDloRGlEOWozeDlrS1Fsd3ZIRGhjYkVwNjBVSmcxTCtCVlJYSVZaNkdOSGVGZ0oyVkN1ckFBT3dvaUdvbk4xWHAyQlZjaUdZdmc5MldFWi8zeFRnV0JGaThobmJwY0dXLzZLWHoydWF4elNHUnVCT1k5MEFSMnd2dG40K3o1Qmo5YjQ5azBHazlxdVZaRkFUVnpNdldQWDRWVWVkYVU0c1FkWnpCam1NQWxzeThaK2ZQRmhUckw2YU1rWHgvbVJWbmVyTE5NOWxWeE1HTDdWQzBrK202VnBEaEV4RjVSeEtBOTZVUWdmOGZxMWVpOGx1SnhSaGN3SlJBMHlFb0xhenJmWkd0MUFhbTFmMm5BVzQ0WHdrUkVGam00NC8ydzR0UVJMTldkdzVRaVVtMFZvdHN0cEUyRlAxUEoxNHlwQVRaN01FUDlqQWpDcUg3aFg1Wjk1ZlY5RmxlUUFBTEZ3UFdWcDBqcDRuZ0lVZEVkKy8xS3QreG9naVp0QVl0OXdPbTlqY1p5S09SemZqalp2eWpkZjlveVJIMGJKUEFTNjJ0cGxzZjRmRU8zdUlpTW1BamZpcmZTMjZJazh4d0NyaG1Ic1ovQWUyL0NlcW5SUWFKWUt0ZG9raW9JS1dXbU1FaEgvQ2c0MWpGc0oxWFJpR1UxT2xnNHFYUi9aVnIyK2VSRDVmWTBTZWVaUXhBaytnZVdBWTVmZkJ2bms4dkhkeGgrZXkxc1lKcVlZYTRKZjkvS2YzbHBGaWVqTWp0ZHJhSVNIUFhBc2xGc1dUSkpDOTBFaWtVZHdJaDRLVjJsZ25HL0hzUFI3NlJOOWJhK1J5M2NnRXFsdzhkU1BBVTFWMnM4c1NVaVB3RmpRdjFlSS80clVzNXVTTG8vcDdZd2UzRFR6V2I5NFJnOVlIR0d6Rmw5WGpvL1FWckc2THRnWGdKZmxQNmp5b1I5dmxNbDdNTWwzUzhkTUR1VVcxZDFZL1NYSm42SnBlVWJ5aEo2MnNqdUpwTkIwRHFnSlExZkdhL29ZYU0wR01EaWxHWXdPbmRSY0JhY3lwc1ZZcG4rWm42bjlFWmRSZTdmZXJYcWNFTk9qWUZJMHZqbUQzY0hmZG9SWjl2eXZRdHZHWnNHUGVXM0dXOFBXSjN1VDlMSk52WEh0ZFhQbGQ5K2hndkVPWWtnUWc2eWhpbkoyWlBTKzd6QVByWUpDcUZvcjZWRktndnFGbUUvQkJKME5GTGFxNVRpc292elErVjBLelBTdnptajhwUzBNdnNJWjlRT3Z3WjQ3cEJ4YmNZRVU1Rnd4MW55WnZ0NTBlekUrQThudVlFWWRZaG9tdHBHU1Z6THYySXp1SjdaeEh0YnA4cWtmNjdUVzlkY25TTzd6dXlKVmtTWjAvajcvaE1UMkZTZnhaNEVtZnNwOVpnV29yOGNYaWN6My8wN25QSGF1WlRCR2I5RjdMRGlHNnhtcFI3ZC9KMGhBM3Y5STU1NHdER2FIV0QxNU5WQXFDZXBtdTFLZm9DTnplMWgwTUloUERYOGhNQ0JpYjZwU0xrT1lYOXUvanpsWUZaRnF2QWY3UmxIZENRPT0iLCJ0aHJlZWRzMi50aHJlZURTU2VydmVyVHJhbnNJRCI6IjcyNjZkM2M5LTc2N2EtNDg2Yi1iOTc1LTJlYjJlMWMyMzQzNiIsInRocmVlZHMyLnRocmVlRFMyRGlyZWN0b3J5U2VydmVySW5mb3JtYXRpb24uYWxnb3JpdGhtIjoiUlNBIiwidGhyZWVkczIudGhyZWVEUzJEaXJlY3RvcnlTZXJ2ZXJJbmZvcm1hdGlvbi5kaXJlY3RvcnlTZXJ2ZXJJZCI6IkYwMTMzNzEzMzciLCJ0aHJlZWRzMi50aHJlZURTMkRpcmVjdG9yeVNlcnZlckluZm9ybWF0aW9uLnB1YmxpY0tleSI6ImV5SnJkSGtpT2lKU1UwRWlMQ0psSWpvaVFWRkJRaUlzSW00aU9pSTRWRkJ4WmtGT1drNHhTVUV6Y0hGdU1rZGhVVlpqWjFnNExVcFdaMVkwTTJkaVdVUnRZbWRUWTBONVNrVlNOM2xQV0VKcVFtUXlhVEJFY1ZGQlFXcFZVVkJYVlV4WlUxRnNSRlJLWW05MWJWQjFhWFZvZVZNeFVITjJOVE00VUhCUlJuRXlTa05hU0VSa2FWODVXVGhWWkc5aGJtbHJVMDk1YzJOSFFXdEJWbUpKV0hBNWNuVk9TbTF3VFRCd1owczVWR3hKU1dWSFlsRTNaRUphUjAxT1FWSkxRWFJLZVRZM2RWbHZiVnBYVjBaQmJXcHdNMmQ0U0RWek56ZENSMnhrYUU5UlVWbFFURmR5YkRkeVMwcExRbFV3Tm0xdFpsa3RVRE5wYXprNU1tdFBVVE5FYWswMmJIUjJXbU52TFRoRVQyUkNSMFJLWW1kV1JHRm1iMjlMVW5WTmQyTlVUWGhEZFRSV1lXcHlObVF5WmtwcFZYbHFOVVl6Y1ZCclluZzRXRGw2YTFjM1VtbHhWbm8yU1UxcWRFNTROelppY21nM2FVOVZkMkppV21veFlXRjZWRzFHUTJ4RWIwZHlZMkp4T1Y4ME5uY2lmUT09In19",
//                "transaction_type" : "Purchase",
//                "gateway_specific_response_fields" : {
//
//                },
//                "currency_code" : "USD",
//                "gateway_latency_ms" : null,
//                "retain_on_success" : false,
//                "callback_url" : "https://example.com/callback",
//                "merchant_name_descriptor" : null,
//                "api_urls" : [
//                {
//                "callback_conversations" : [
//                "http://core.spreedly.test/v1/callbacks/EAHsxQXpxWziO8veeI3h2DgLBC5/conversations.xml"
//                ]
//                },
//                {
//                "referencing_transaction" : [
//
//                ]
//                }
//                ],
//                "token" : "HJnxlg6eToIM51khyJCk5H13XZ1",
//                "created_at" : "2019-08-21T18:27:57Z",
//                "message_key" : "messages.transaction_pending",
//                "redirect_url" : "https://example.com/redirect",
//                "message" : "Pending",
//                "description" : null,
//                "checkout_url" : null
//            }
//        }
//        """
//
//        return JSON(parseJSON: response)
    }
}
