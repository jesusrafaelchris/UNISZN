//
//  ForgotPassword.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 09/07/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import AnimatedGradientView

class ForgotPassword: UIViewController {
    
    private let EmailField: UITextField = {
        let emailField = UITextField()
        emailField.backgroundColor = .white
        emailField.placeholder = "Email"
        emailField.layer.cornerRadius = 19
        emailField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailField.frame.height))
        emailField.leftView = paddingView
        emailField.leftViewMode = UITextField.ViewMode.always
        emailField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        return emailField
    }()

    private let ResetPasswordText: UILabel = {
        let ResetPasswordText = UILabel()
        ResetPasswordText.text = "Reset Password"
        ResetPasswordText.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        ResetPasswordText.textColor = .white
        ResetPasswordText.translatesAutoresizingMaskIntoConstraints = false
        ResetPasswordText.adjustsFontSizeToFitWidth = true
        ResetPasswordText.minimumScaleFactor = 0.5
        ResetPasswordText.textAlignment = .center
        return ResetPasswordText
    }()
    
    private let resetpasswordButton: UIButton = {
        let resetpasswordButton = UIButton()
        resetpasswordButton.setTitle("Reset", for: .normal)
        resetpasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        resetpasswordButton.setTitleColor(.systemBlue, for: .normal)
        resetpasswordButton.backgroundColor = .white
        resetpasswordButton.layer.cornerRadius = 20
        resetpasswordButton.layer.masksToBounds = true
        resetpasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetpasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetpasswordButton.titleLabel?.minimumScaleFactor = 0.5
        resetpasswordButton.titleLabel?.textAlignment = .center
        return resetpasswordButton
        }()
    
    lazy var gradient: AnimatedGradientView = {
      let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationDuration = 2
        animatedGradient.animationValues = [(colors: ["#367588", "#16A4AE"], .up, .axial),
        (colors: ["#16A4AE"], .right, .axial),
        (colors: ["#367588"], .down, .axial),
        (colors: ["#16A4AE"], .left, .axial)]
        return animatedGradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetpasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        view.addSubview(gradient)
        
        gradient.addSubview(EmailField)
        gradient.addSubview(ResetPasswordText)
        gradient.addSubview(resetpasswordButton)
        
    // ResetPasswordText constraints
        ResetPasswordText.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        ResetPasswordText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ResetPasswordText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        ResetPasswordText.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    //email textinput constraints
        EmailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        EmailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        EmailField.topAnchor.constraint(equalTo: ResetPasswordText.bottomAnchor, constant: 40).isActive = true
        EmailField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
    // resetpasswordButton constraints
        resetpasswordButton.topAnchor.constraint(equalTo: EmailField.bottomAnchor, constant: 30).isActive = true
        resetpasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetpasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        resetpasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func forgotPassword() {
        guard let email = EmailField.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
            if let error = error {
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
                }
            else {
                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
            }
        }

}
