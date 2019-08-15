//
//  CreditCardViewController.swift
//  Spreedly-iOS-Sample
//
//  Created by David Santoso on 8/15/19.
//  Copyright © 2019 Spreedly. All rights reserved.
//

import Foundation
import UIKit
import Spreedly

class CreditCardViewController: UIViewController {
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cardMonth: UITextField!
    @IBOutlet weak var cardYear: UITextField!
    @IBOutlet weak var cardVerificationValue: UITextField!
    @IBOutlet weak var gatewayToken: UITextField!
    @IBOutlet weak var attempt3DSecure: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePurchaseTapped(_ sender: AnyObject) {
        let card = [
            "number": self.cardNumber.text!,
            "month": self.cardMonth.text!,
            "year": self.cardYear.text!,
            "verificationValue": self.cardVerificationValue.text!
        ]
        
        let options = [
            "attempt3DSecure": "\(self.attempt3DSecure.isOn)",
            "gatewayToken": self.gatewayToken.text!
        ]
        
        SpreedlyBackend.purchase(amount: 12100, card: card, options: options, purchaseCompletion: { response in
            let txToken = response["transaction"]["token"].stringValue
            
            if response["transaction"]["state"] == "succeeded" {
                let token = response["transaction"]["token"].stringValue
                self.showAlertView("Success", message: "Token: \(token)")
                
            } else if response["transaction"]["state"] == "pending" {
                let nextAction = response["transaction"]["required_action"].stringValue
                let lifecycle = Spreedly.instance.threeDsInit(rawThreeDsContext: response["transaction"]["three_ds_context"].stringValue)
                
                if nextAction == "device_fingerprint" {
                    lifecycle.getDeviceFingerprintData(fingerprintDataCompletion: { fingerprintData in
                        SpreedlyBackend.purchase_continue(transactionToken: txToken, threeDSData: fingerprintData, continueCompletion: { response in
                            let challengeContext = response["transaction"]["three_ds_context"].stringValue
                            
                            lifecycle.doChallenge(rawThreeDsContext: challengeContext, challengeCompletion: { challengeData in
                                SpreedlyBackend.purchase_continue(transactionToken: txToken, threeDSData: challengeData, continueCompletion: { response in
                                    let token = response["transaction"]["token"].stringValue
                                    self.showAlertView("Success", message: "Token: \(token)")
                                })
                            })
                        })
                    })
                    
                } else if nextAction == "challenge" {
                    let challengeContext = response["transaction"]["three_ds_context"].stringValue
                    
                    lifecycle.doChallenge(rawThreeDsContext: challengeContext, challengeCompletion: { challengeData in
                        SpreedlyBackend.purchase_continue(transactionToken: txToken, threeDSData: challengeData, continueCompletion: { response in
                            let token = response["transaction"]["token"].stringValue
                            self.showAlertView("Success", message: "Token: \(token)")
                        })
                    })
                    
                } else {
                    let token = response["transaction"]["token"].stringValue
                    self.showAlertView("Success", message: "Token: \(token)")
                }
            } else {
                print("======== ERROR ========")
                print(response)
                self.showAlertView("Failed", message: "See log for failure")
            }
        })
    }
    
    func showAlertView(_ title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func extractMonth(_ expiration: String) -> String {
        return(splitExpirationString(expiration).first!)
    }
    
    func extractYear(_ expiration: String) -> String {
        return("20" + splitExpirationString(expiration).last!)
    }
    
    func splitExpirationString(_ expiration: String) -> [String] {
        let expirationArray = expiration.components(separatedBy: "/")
        return expirationArray
    }
}
