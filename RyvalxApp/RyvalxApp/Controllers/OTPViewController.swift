//
//  OTPViewController.swift
//  RyvalxApp
//
//  Created by Abishek on 08/05/26.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var otpSubtitleLabel: UILabel!
    
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var otpTextField5: UITextField!
    @IBOutlet weak var otpTextField6: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSubtitleText()
        
        otpTextField1.becomeFirstResponder()
    }
    
    
    func setupUI() {
        
        view.backgroundColor = UIColor(
            red: 0.95,
            green: 0.96,
            blue: 0.97,
            alpha: 1.0
        )
        
        let textFields = [
            otpTextField1,
            otpTextField2,
            otpTextField3,
            otpTextField4,
            otpTextField5,
            otpTextField6
        ]
        
        textFields.forEach { textField in
            
            textField?.layer.cornerRadius = 12
            textField?.clipsToBounds = true
            textField?.backgroundColor = .white
            
            textField?.textAlignment = .center
            textField?.keyboardType = .numberPad
            textField?.delegate = self
            
            textField?.font = UIFont.boldSystemFont(ofSize: 24)
            textField?.textColor = .black
            
            textField?.tintColor = .clear
            
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        verifyButton.layer.cornerRadius = 10
        verifyButton.clipsToBounds = true
    }
    
    
    func setupSubtitleText() {
        
        let fullText = """
        Enter the 6-digit code we've sent to keep your account secure. +91 9677228900 Edit Number?
        """
        
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .foregroundColor: UIColor(
                    red: 0.62,
                    green: 0.67,
                    blue: 0.74,
                    alpha: 1.0
                ),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        if let numberRange = fullText.range(of: "+91 9677228900") {
            
            attributedText.addAttributes([
                .foregroundColor: UIColor(
                    red: 0.25,
                    green: 0.25,
                    blue: 0.35,
                    alpha: 1.0
                ),
                .font: UIFont.boldSystemFont(ofSize: 15)
            ], range: NSRange(numberRange, in: fullText))
        }
        
        if let editRange = fullText.range(of: "Edit Number?") {
            
            attributedText.addAttributes([
                .foregroundColor: UIColor(
                    red: 0.21,
                    green: 0.73,
                    blue: 0.88,
                    alpha: 1.0
                ),
                .font: UIFont.boldSystemFont(ofSize: 15)
            ], range: NSRange(editRange, in: fullText))
        }
        
        otpSubtitleLabel.attributedText = attributedText
    }
    
    
    @IBAction func verifyCodeTapped(_ sender: UIButton) {
        
        let otp = [
            otpTextField1.text ?? "",
            otpTextField2.text ?? "",
            otpTextField3.text ?? "",
            otpTextField4.text ?? "",
            otpTextField5.text ?? "",
            otpTextField6.text ?? ""
        ].joined()
        
        print("OTP:", otp)
        
        if otp.count == 6 {
            showAlert(message: "OTP Verified Successfully")
        } else {
            showAlert(message: "Please enter valid OTP")
        }
    }
    
    
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        showAlert(message: "OTP Resent Successfully")
    }
    
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(
            title: "Ryvalx",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    
                    if message == "OTP Verified Successfully" {
                        
                        let storyboard = UIStoryboard(
                            name: "Main",
                            bundle: nil
                        )
                        
                        if let dashboardVC =
                            storyboard.instantiateViewController(
                                withIdentifier: "DashboardViewController"
                            ) as? DashboardViewController {
                            
                            self.navigationController?.pushViewController(
                                dashboardVC,
                                animated: true
                            )
                        }
                    }
                }
            )
        )
        
        present(alert, animated: true)
    }
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let allowedCharacterSet = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacterSet.isSuperset(of: characterSet)
            && !string.isEmpty {
            
            return false
        }
        
        if string.isEmpty {
            
            textField.text = ""
            
            switch textField {
                
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
                
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
                
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
                
            case otpTextField5:
                otpTextField4.becomeFirstResponder()
                
            case otpTextField6:
                otpTextField5.becomeFirstResponder()
                
            default:
                break
            }
            
            return false
        }
        
        if textField.text?.count == 0 {
            
            textField.text = string
            
            switch textField {
                
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
                
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
                
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
                
            case otpTextField4:
                otpTextField5.becomeFirstResponder()
                
            case otpTextField5:
                otpTextField6.becomeFirstResponder()
                
            case otpTextField6:
                otpTextField6.resignFirstResponder()
                
            default:
                break
            }
        }
        
        return false
    }
}

