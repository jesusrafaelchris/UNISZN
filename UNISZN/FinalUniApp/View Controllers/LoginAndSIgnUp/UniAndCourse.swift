//
//  UniAndCourse.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import AnimatedGradientView

protocol ModalDelegate: AnyObject {
func changeValuecourse(value: String)
func changeValueuniversity(value: String)
}

class UniAndCourse: UIViewController, ModalDelegate {

    
    func changeValueuniversity(value: String) {
        uni = value
        UniField.text = uni
    }
 
    func changeValuecourse(value: String) {
        course = value
        CourseField.text = value
    }

    var uni: String?
    var course: String?

    private let LogoImage: UIImageView = {
        let Image = UIImage(named: "logo")
        let image = UIImageView(image: Image)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let Signuplabel: UILabel = {
        let Signuplabel = UILabel()
        Signuplabel.text = "Sign Up"
        Signuplabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        Signuplabel.textColor = .white
        Signuplabel.translatesAutoresizingMaskIntoConstraints = false
        return Signuplabel
    }()
    
   lazy var UniField: UITextField = {
        let UniField = UITextField()
        UniField.backgroundColor = .white
        UniField.placeholder = "Choose Your University"
        UniField.layer.cornerRadius = 19
        UniField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: UniField.frame.height))
        UniField.leftView = paddingView
        UniField.leftViewMode = UITextField.ViewMode.always
        UniField.autocapitalizationType = .none
        UniField.translatesAutoresizingMaskIntoConstraints = false
        return UniField
    }()
    
    lazy var CourseField: UITextField = {
        let CourseField = UITextField()
        CourseField.backgroundColor = .white
        CourseField.placeholder = "Choose Your Course"
        CourseField.layer.cornerRadius = 19
        CourseField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: CourseField.frame.height))
        CourseField.leftView = paddingView
        CourseField.leftViewMode = UITextField.ViewMode.always
        CourseField.autocapitalizationType = .none
        CourseField.translatesAutoresizingMaskIntoConstraints = false
         return CourseField
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
    
    private let CourseNotSupported: UILabel = {
        let CourseNotSupported = UILabel()
        CourseNotSupported.numberOfLines = 0
        CourseNotSupported.textAlignment = .center
        CourseNotSupported.text = "Don't see your course? Select \n (Pending Addition) and message us to add it in"
        CourseNotSupported.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        CourseNotSupported.textColor = .white
        CourseNotSupported.translatesAutoresizingMaskIntoConstraints = false
        return CourseNotSupported
    }()
    
    private let UniNotSupported: UILabel = {
        let CourseNotSupported = UILabel()
        CourseNotSupported.numberOfLines = 0
        CourseNotSupported.textAlignment = .center
        CourseNotSupported.text = "Don't see your Uni? Select \n (Pending Addition) and message us to add it in"
        CourseNotSupported.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        CourseNotSupported.textColor = .white
        CourseNotSupported.translatesAutoresizingMaskIntoConstraints = false
        return CourseNotSupported
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
        self.UniField.delegate = self
        self.CourseField.delegate = self
        setupnavigationbar()
        addsubviews()
        setupgestures()
        setupView()
        setupgestures()
    }
    
    @objc func ShowUnis(gesture: UITapGestureRecognizer){
        print("unis")
        let unichoice = University()
        unichoice.delegate = self
        self.navigationController?.present(unichoice, animated: true, completion: nil)
     }
    
    @objc func ShowCourses(gesture: UITapGestureRecognizer){
        print("Courses")
        let coursechoice = Course()
        coursechoice.delegate = self
        self.navigationController?.present(coursechoice, animated: true, completion: nil)
    }
     
     @objc func nextPage() {
        self.showSpinner(onView: self.view)
        let batch = Firestore.firestore().batch()
        if self.UniField.text?.isEmpty ?? true {
            Alert("University")
            self.removeSpinner()
            return
        }
               
        if self.CourseField.text?.isEmpty ?? true {
        Alert("Course")
        self.removeSpinner()
        return
        }
            
        else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let Uni = uni else {return}
            guard let Course = course else {return}
            let Data: [String : Any] = [uid: true]
            
            let UniCourseRef = Firestore.firestore().collection("Universities").document(Uni).collection(Course).document(uid)
            let UniTotalRef = Firestore.firestore().collection("Universities").document(Uni).collection("Total").document(uid)
            
            batch.setData(Data, forDocument: UniTotalRef, merge: true)
            
            batch.setData(Data, forDocument: UniCourseRef, merge: true)

            batch.commit { (error) in
                if error != nil {
                    self.Alert(error!.localizedDescription)
                }
                else {
                    self.removeSpinner()
                    self.navigationController?.dismiss(animated: true, completion: {
                    print("dismissed")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadhome"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadprofile"), object: nil)
                        })
                    }
                }
            }
        }
     
     func setupnavigationbar() {
         self.navigationController?.navigationBar.tintColor = .white
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
     }
     
     func setupgestures() {
         let UniGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowUnis(gesture:)))
        let CourseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowCourses(gesture:)))
         self.UniField.isUserInteractionEnabled = true
         self.CourseField.isUserInteractionEnabled = true
         UniGestureRecognizer.numberOfTapsRequired = 1
         CourseGestureRecognizer.numberOfTapsRequired = 1
         self.UniField.addGestureRecognizer(UniGestureRecognizer)
         self.CourseField.addGestureRecognizer(CourseGestureRecognizer)
         nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
         
     }
     
     func addsubviews() {
         view.addSubview(gradient)
         gradient.addSubview(LogoImage)
         gradient.addSubview(Signuplabel)
         gradient.addSubview(UniField)
         gradient.addSubview(CourseField)
         gradient.addSubview(nextButton)
         gradient.addSubview(CourseNotSupported)
         gradient.addSubview(UniNotSupported)
     }
    
    func Alert(_ field:String){
       let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
    }
     
     
     func setupView() {
         
     let betweentextfieldsconstant = CGFloat(50)
        
    //Logo Image Constraints
         LogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         LogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
         LogoImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
         LogoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
         LogoImage.heightAnchor.constraint(equalTo: LogoImage.widthAnchor).isActive = true

    // LoginText constraints
         Signuplabel.topAnchor.constraint(equalTo: LogoImage.bottomAnchor, constant: -40).isActive = true
         Signuplabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
         Signuplabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
         Signuplabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
         
    //email textinput constraints
         UniField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
         UniField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
         UniField.topAnchor.constraint(equalTo: Signuplabel.bottomAnchor, constant: 40).isActive = true
         UniField.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    //password textfield constraints
         CourseField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
         CourseField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
         CourseField.topAnchor.constraint(equalTo: UniField.bottomAnchor, constant: betweentextfieldsconstant).isActive = true
         CourseField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
    //coursenotsupported button
        CourseNotSupported.topAnchor.constraint(equalTo: CourseField.bottomAnchor, constant: 5).isActive = true
        CourseNotSupported.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    //coursenotsupported button
        UniNotSupported.topAnchor.constraint(equalTo: UniField.bottomAnchor, constant: 5).isActive = true
        UniNotSupported.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    //next button constraints
         nextButton.topAnchor.constraint(equalTo: CourseNotSupported.bottomAnchor, constant: 45).isActive = true
         nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
         nextButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
         nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
         
     }
}

extension UniAndCourse: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == UniField || textField == CourseField {
            return false //do not show keyboard nor cursor
        }
        return true
    }
}
