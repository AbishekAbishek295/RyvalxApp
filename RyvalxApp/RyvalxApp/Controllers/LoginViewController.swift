//
//  ViewController.swift
//  RyvalxApp
//
//  Created by Abishek on 08/05/26.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        phoneTextField.delegate = self
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor(
            red: 0.95,
            green: 0.96,
            blue: 0.97,
            alpha: 1.0
        )
        
        flagImageView.image = UIImage(named: "india")
        downImageView.image = UIImage(named: "down")
        
        flagImageView.contentMode = .scaleAspectFit
        downImageView.contentMode = .scaleAspectFit
        
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.layer.borderWidth = 0
        phoneTextField.clipsToBounds = true
        phoneTextField.keyboardType = .numberPad
        phoneTextField.setLeftPadding(12)
        
        sendButton.layer.cornerRadius = 10
        sendButton.clipsToBounds = true
        
        signupButton.setTitleColor(
            UIColor(
                red: 0.21,
                green: 0.73,
                blue: 0.88,
                alpha: 1.0
            ),
            for: .normal
        )
    }
    
    
    @IBAction func sendCodeTapped(_ sender: UIButton) {
        
        guard let phoneNumber = phoneTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !phoneNumber.isEmpty else {
            
            showAlert(message: "Please enter mobile number")
            return
        }
        
        if phoneNumber.count != 10 {
            
            showAlert(message: "Please enter valid 10 digit mobile number")
            return
        }
        
        print("Phone Number:", phoneNumber)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let otpVC = storyboard.instantiateViewController(
            withIdentifier: "OTPViewController"
        ) as? OTPViewController {
            
            navigationController?.pushViewController(otpVC, animated: true)
            
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        print("Sign Up tapped")
    }
    
    
     func showAlert(message: String) {
        
        let alert = UIAlertController(
            title: "Ryvalx",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}


extension UITextField {
    
    func setLeftPadding(_ amount: CGFloat) {
        
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: amount,
                height: self.frame.height
            )
        )
        
        leftView = paddingView
        leftViewMode = .always
    }
}
