//
//  EmailPassword.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 04/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import AnimatedGradientView

class EmailPassword: UIViewController {
    
    let docRef = Firestore.firestore().collection("users")
    
    private let LogoImage: UIImageView = {
        let Image = UIImage(named: "logo")
        let image = UIImageView(image: Image)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let TermsAndConditions: UILabel = {
        let label = UILabel()
        label.text = "By creating an account you agree to Uniszn's"
        label.font = UIFont.systemFont(ofSize: 8, weight: UIFont.Weight.bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let termsAndConditionsButton: UIButton = {
       let button = UIButton()
        let underlineAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white]
        let underlineAttributedString = NSAttributedString(string: "Terms of Use", attributes: underlineAttribute)
        button.setAttributedTitle(underlineAttributedString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: UIFont.Weight.bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(linkClicked(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    private let Signuplabel: UILabel = {
        let Signuplabel = UILabel()
        Signuplabel.text = "Email"
        Signuplabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        Signuplabel.textColor = .white
        Signuplabel.translatesAutoresizingMaskIntoConstraints = false
        return Signuplabel
    }()
    
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
    
    private let PasswordField: UITextField = {
        let passwordField = UITextField()
        passwordField.backgroundColor = .white
        passwordField.placeholder = "Password"
        passwordField.layer.cornerRadius = 19
        passwordField.layer.masksToBounds = true
        passwordField.isSecureTextEntry = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: passwordField.frame.height))
        passwordField.leftView = paddingView
        passwordField.leftViewMode = UITextField.ViewMode.always
        passwordField.autocapitalizationType = .none
        passwordField.translatesAutoresizingMaskIntoConstraints = false
         return passwordField
     }()
    
    private let RetypePasswordField: UITextField = {
       let RetypePasswordField = UITextField()
       RetypePasswordField.backgroundColor = .white
       RetypePasswordField.placeholder = "Re-type Password"
       RetypePasswordField.layer.cornerRadius = 19
       RetypePasswordField.layer.masksToBounds = true
       RetypePasswordField.isSecureTextEntry = true
       let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: RetypePasswordField.frame.height))
       RetypePasswordField.leftView = paddingView
       RetypePasswordField.leftViewMode = UITextField.ViewMode.always
       RetypePasswordField.autocapitalizationType = .none
       RetypePasswordField.translatesAutoresizingMaskIntoConstraints = false
        return RetypePasswordField
        }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 20
        nextButton.layer.masksToBounds = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
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
        self.view.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = false
        self.RetypePasswordField.delegate = self
        setupnavigationbar()
        addsubviews()
        setupgestures()
        setupView()
    }
    
    @objc func linkClicked(sender: Any) {
        openUrl(urlStr: "http://www.uniszn.com/terms-and-conditions/")
    }

    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        EmailField.resignFirstResponder()
        PasswordField.resignFirstResponder()
        RetypePasswordField.resignFirstResponder()
    }
    
    @objc func nextPage() {
        //let firstsurusername = NameAndUsername()
        //self.navigationController?.pushViewController(firstsurusername, animated: true)
        confirmEmailPassword()
    }
    
    func setupnavigationbar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupgestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        self.EmailField.isUserInteractionEnabled = true
        self.PasswordField.isUserInteractionEnabled = true
        self.RetypePasswordField.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
    }
    
    func addsubviews() {
        view.addSubview(gradient)
        gradient.addSubview(LogoImage)
        gradient.addSubview(Signuplabel)
        gradient.addSubview(EmailField)
        gradient.addSubview(PasswordField)
        gradient.addSubview(RetypePasswordField)
        gradient.addSubview(nextButton)
        gradient.addSubview(termsAndConditionsButton)
        gradient.addSubview(TermsAndConditions)
    }
    
    
    func setupView() {
        
    let betweentextfieldsconstant = CGFloat(40)
   //Logo Image Constraints
   LogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   LogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
   LogoImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
   LogoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
   LogoImage.heightAnchor.constraint(equalTo: LogoImage.widthAnchor).isActive = true

   // Signuplabel constraints
    Signuplabel.topAnchor.constraint(equalTo: LogoImage.bottomAnchor, constant: -40).isActive = true
    Signuplabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    Signuplabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
    Signuplabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
   //email textinput constraints
    EmailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    EmailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    EmailField.topAnchor.constraint(equalTo: Signuplabel.bottomAnchor, constant: 40).isActive = true
    EmailField.heightAnchor.constraint(equalToConstant: 38).isActive = true
   
   //password textfield constraints
    PasswordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    PasswordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    PasswordField.topAnchor.constraint(equalTo: EmailField.bottomAnchor, constant: betweentextfieldsconstant).isActive = true
    PasswordField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
   //retypepassword textfield constraints
    RetypePasswordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    RetypePasswordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    RetypePasswordField.topAnchor.constraint(equalTo: PasswordField.bottomAnchor, constant: betweentextfieldsconstant).isActive = true
    RetypePasswordField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
    //termsandconditions
    TermsAndConditions.topAnchor.constraint(equalTo: RetypePasswordField.bottomAnchor, constant: 5).isActive = true
    TermsAndConditions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    termsAndConditionsButton.topAnchor.constraint(equalTo: TermsAndConditions.bottomAnchor, constant: 2).isActive = true
    termsAndConditionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
   //login button constraints
    nextButton.topAnchor.constraint(equalTo: RetypePasswordField.bottomAnchor, constant: 50).isActive = true
    nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    nextButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    func confirmEmailPassword() {
   //     let firstsurusername = NameAndUsername()
     //   self.navigationController?.pushViewController(firstsurusername, animated: true)
        guard let Password = self.PasswordField.text else {return}
        guard let email = self.EmailField.text else {return}
        guard let retypedpassword = self.RetypePasswordField.text else {return}
        let password = Password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password != retypedpassword {
        AlertofError("Passwords don't match", "Please Retype Password")
            return
        }
            
       else if service.isPasswordValid(password) == false {
            AlertofError("Password not strong enough", "Please ensure your password is at least 8 characters, contains a number and a special character ($@$#!%*?&).")
            return
        }
            
        else {
            service.createUser(email: email, password: password) {[weak self] (success, error)  in
                    guard let strongSelf = self else { return }
                    if (success) {
                        let firstsurusername = NameAndUsername()
                        strongSelf.navigationController?.pushViewController(firstsurusername, animated: true)
                    } else {
                        guard let Error = error else {return}
                        self?.handleError(Error)
                    }
                }
            }
        }
    
    func AlertofError(_ error:String, _ Message:String){
        let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension EmailPassword: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextPage()
        return true
    }
}
