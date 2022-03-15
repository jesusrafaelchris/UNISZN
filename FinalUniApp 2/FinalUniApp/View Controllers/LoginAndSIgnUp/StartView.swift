//
//  StartView.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 04/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import AnimatedGradientView
import FirebaseCrashlytics

class StartView: UIViewController {

    let BlueBackground = UIColor(red: 54, green: 117, blue: 136, alpha: 1)
    
    private let LogoImage: UIImageView = {
        let Image = UIImage(named: "logo")
        let image = UIImageView(image: Image)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let LoginText: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        loginLabel.textColor = .white
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private let DontHaveAccountText: UILabel = {
           let DontHaveAccountText = UILabel()
           DontHaveAccountText.text = "Don't Have An Account?"
           DontHaveAccountText.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
           DontHaveAccountText.textColor = .white
           DontHaveAccountText.translatesAutoresizingMaskIntoConstraints = false
           return DontHaveAccountText
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
        passwordField.isSecureTextEntry = true
        passwordField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: passwordField.frame.height))
        passwordField.leftView = paddingView
        passwordField.leftViewMode = UITextField.ViewMode.always
        passwordField.autocapitalizationType = .none
        passwordField.translatesAutoresizingMaskIntoConstraints = false
         return passwordField
     }()
    
    private let LoginButton: UIButton = {
        let loginbutton = UIButton()
        loginbutton.setTitle("LOGIN", for: .normal)
        loginbutton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        loginbutton.setTitleColor(.systemBlue, for: .normal)
        loginbutton.backgroundColor = .white
        loginbutton.layer.cornerRadius = 20
        loginbutton.layer.masksToBounds = true
        loginbutton.translatesAutoresizingMaskIntoConstraints = false
        return loginbutton
    }()
    //UIColor(red: 0.21, green: 0.46, blue: 0.53, alpha: 1.00)
    private let signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        signupButton.setTitleColor(.systemBlue, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = .white
        signupButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
        return signupButton
    }()
    
    private let forgotpasswordbutton: UIButton = {
        let forgotpasswordbutton = UIButton()
        //forgotpasswordbutton.setTitle("Forgot Your password?", for: .normal)
        let underlineAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white]
        let underlineAttributedString = NSAttributedString(string: "Forgot Your password?", attributes: underlineAttribute)
        forgotpasswordbutton.setAttributedTitle(underlineAttributedString, for: .normal)
        forgotpasswordbutton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        forgotpasswordbutton.setTitleColor(.white, for: .normal)
        forgotpasswordbutton.translatesAutoresizingMaskIntoConstraints = false
        return forgotpasswordbutton
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
        self.definesPresentationContext = true
        self.PasswordField.delegate = self
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        addsubviews()
        setupactions()
        setupView()
    }
    
    
    func gradientbackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0).cgColor, UIColor(red: 0.07, green: 0.56, blue: 0.59, alpha: 1.00).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool){
     super.viewDidAppear(animated)

    }
    
    func setupactions() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        self.EmailField.isUserInteractionEnabled = true
        self.PasswordField.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        LoginButton.addTarget(self, action: #selector(Login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
        forgotpasswordbutton.addTarget(self, action: #selector(toForgotPassword), for: .touchUpInside)
        
    }
    
    
    func addsubviews() {
        view.addSubview(gradient)
        gradient.addSubview(EmailField)
        gradient.addSubview(PasswordField)
        gradient.addSubview(LoginText)
        gradient.addSubview(LogoImage)
        gradient.addSubview(LoginButton)
        //gradient.addSubview(DontHaveAccountText)
        gradient.addSubview(signupButton)
        gradient.addSubview(forgotpasswordbutton)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        EmailField.resignFirstResponder()
        PasswordField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func Login() {
    Auth.auth().signIn(withEmail: EmailField.text!, password: PasswordField.text!) { [weak self] (user, error) in
       
        guard let StrongSelf = self else {
            return
        }
        guard let result = user, error == nil else {
            print(error!._code)
            self?.handleError(error!)
            return
        }
        
        let user = result.user
        print("logged in \(user)")
        
        StrongSelf.navigationController?.dismiss(animated: true, completion: {
            print("dismissed")
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadhome"), object: nil)
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadprofile"), object: nil)
        })
    }
}

    
    @objc func SignUp() {
        let emailPassword = EmailPassword()
        navigationController?.pushViewController(emailPassword, animated: true)
    }
    
    func Alert(_ error:Error){
       let alertController = UIAlertController(title: "Sorry", message: "\(error)", preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
          }
    
    @objc func toForgotPassword() {
        let forgotpassword = ForgotPassword()
        navigationController?.present(forgotpassword, animated: true, completion: nil)
    }
    
    
   func setupView() {
    
    //Logo Image Constraints
    LogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    LogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    LogoImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
    LogoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
    LogoImage.heightAnchor.constraint(equalTo: LogoImage.widthAnchor).isActive = true
    
    // LoginText constraints
    LoginText.topAnchor.constraint(equalTo: LogoImage.bottomAnchor, constant: -40).isActive = true
    LoginText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    LoginText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
    LoginText.heightAnchor.constraint(equalToConstant: 45).isActive = true
    
    //email textinput constraints
    EmailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    EmailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    EmailField.topAnchor.constraint(equalTo: LoginText.bottomAnchor, constant: 40).isActive = true
    EmailField.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    //password textfield constraints
    PasswordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    PasswordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    PasswordField.topAnchor.constraint(equalTo: EmailField.bottomAnchor, constant: 30).isActive = true
    PasswordField.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    //login button constraints
    LoginButton.topAnchor.constraint(equalTo: PasswordField.bottomAnchor, constant: 30).isActive = true
    LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    LoginButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
    LoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    //forgot password button constraints
    forgotpasswordbutton.topAnchor.constraint(equalTo: LoginButton.bottomAnchor,constant: 10).isActive = true
    forgotpasswordbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    // donthaveaccount label constraints
    //DontHaveAccountText.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -5).isActive = true
    //DontHaveAccountText.heightAnchor.constraint(equalToConstant: 30).isActive = true
    //DontHaveAccountText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    // signup button constraints
    signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    signupButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    signupButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true

    }

}

extension StartView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Login()
        return true
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again."
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
}
