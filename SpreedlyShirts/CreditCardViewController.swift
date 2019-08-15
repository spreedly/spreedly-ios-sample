//
//  CreditCardViewController.swift
//  SpreedlyShirts
//
//  Created by David Santoso on 8/15/19.
//  Copyright © 2019 Spreedly. All rights reserved.
//

import Foundation
import UIKit
import Spreedly

class CreditCardViewController: UIViewController {
    
    @IBOutlet weak var cardFirstName: UITextField!
    @IBOutlet weak var cardLastName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cardExpiration: UITextField!
    @IBOutlet weak var cardVerificationValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBuyNowTapped(_ sender: AnyObject) {
        let creditCard = CreditCard()
        creditCard.firstName = self.cardFirstName.text!
        creditCard.lastName = self.cardLastName.text!
        creditCard.number = self.cardNumber.text!
        creditCard.month = extractMonth(self.cardExpiration.text!)
        creditCard.year = extractYear(self.cardExpiration.text!)
        creditCard.verificationValue = self.cardVerificationValue.text!
        
        let client = SpreedlyAPIClient(environmentKey: environmentKey)
        client.createPaymentMethodTokenWithCreditCard(creditCard) { paymentMethod, error -> Void in
            if error != nil {
                print(error!)
                self.showAlertView("Error", message: error!.description)
            } else {
                print(paymentMethod!.token!)
                self.showAlertView("Success", message: "Token: \(paymentMethod!.token!)")
                
                // On success, you can now send a request to your backend to finish the charge
                // via an authenticated API call. Just pass the payment method token you recieved
            }
        }
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
