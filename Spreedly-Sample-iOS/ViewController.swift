//
//  ViewController.swift
//  Spreedly-Sample-iOS
//
//  Created by David Santoso on 10/8/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import UIKit
import PassKit
import Spreedly

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBAction func unwindToRoot (_ segue: UIStoryboardSegue?) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTest3DSFlowTapped(_ sender: AnyObject) {
        SpreedlyBackend.purchase(amount: 12100, purchaseCompletion: { response in
            print("==================== PURCHASE ====================")
            print(response)
            let txToken = response["transaction"]["token"].stringValue
            
            let lifecycle = Spreedly.instance.threeDsInit(rawThreeDsContext: response["transaction"]["three_ds_context"].stringValue)
            
            lifecycle.getDeviceFingerprintData(fingerprintDataCompletion: { fingerprintData in
                print("==================== FINGERPRINT ====================")
                print(fingerprintData)
                SpreedlyBackend.purchase_continue(transactionToken: txToken, threeDSData: fingerprintData, continueCompletion: { response in
                    
                    let challengeContext = response["transaction"]["three_ds_context"].stringValue
                    lifecycle.doChallenge(rawThreeDsContext: challengeContext, challengeCompletion: { result in
                        print("==================== CHALLENGE ====================")
                        print(result)
                    })
                })
            })
        })
    }
    
    @IBAction func handleApplePayTapped(_ sender: AnyObject) {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = appleMerchantId
        paymentRequest.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.amex, PKPaymentNetwork.masterCard]
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentRequest.supportedNetworks) {
            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "Snuggie", amount: NSDecimalNumber(string: "20.00")),
                PKPaymentSummaryItem(label: "Super Snuggles Inc.", amount: NSDecimalNumber(string: "20.00"))
            ]
            
            let paymentAuthVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthVC?.delegate = self
            present(paymentAuthVC!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Apple Pay not supported on this device", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion:(@escaping (PKPaymentAuthorizationStatus) -> Void)) {
        
        let client = SpreedlyAPIClient(environmentKey: environmentKey)
        client.createPaymentMethodTokenWithApplePay(payment) { paymentMethod, error -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.failure)
            }
            else {
                if let token = paymentMethod!.token {
                    // On success, you can now send a request to your backend to finish the charge
                    // via an authenticated API call. Just pass the payment method token you recieved
                    // if all of that goes well, you can now pass success to the completion to
                    // close the Apple Pay pop over
                    print(token)
                    
                    completion(PKPaymentAuthorizationStatus.success)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
}

