//
//  PostingPage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 20/09/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

protocol addpoint {
    func Addpoint(name: String, uid: String, x: CGFloat, y: CGFloat)
}

class PostingPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, addpoint, UITextFieldDelegate {
    
    
    var uid: String?
    var username: String?
    var tagArray = [TagClass]()
    
    
    lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        return picker
    }()
    
    lazy var PickedImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .red
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        navigationItem.title = "Tag People"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissPage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(NextPage))

        PickedImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.PickedImage.addGestureRecognizer(tapGestureRecognizer)
        
    }

     @objc func tapAction(sender: UITapGestureRecognizer) {
          let usersToTag = FriendsListToTagFrom()
          usersToTag.delegate = self
          let touchPoint = sender.location(in: self.PickedImage)
          print(touchPoint)

          let z1 = touchPoint.x
          let z2 = touchPoint.y
          print("Before Alert Touched point (\(z1), \(z2)")

          //convert point into Percentage
          let z1per =  z1 * 100 / self.PickedImage.frame.size.width
          let z2per =  z2 * 100 / self.PickedImage.frame.size.height

          print("After Alert Touched point (\(z1per), \(z2per)")

        
      //whatever you want to add like button or image on tap action.
        usersToTag.touchPointx = touchPoint.x
        usersToTag.touchPointy = touchPoint.y
        
        present(usersToTag, animated: true, completion: nil)

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    
    func Addpoint(name: String, uid: String, x: CGFloat, y: CGFloat) {
        
        print(name,uid, x, y)
        let textfield = DraggableView()
        textfield.uid = uid
        textfield.name = name
        textfield.delegate = self
        textfield.font = UIFont.boldSystemFont(ofSize: 15)
        textfield.text = name
        textfield.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        textfield.textColor = .white
        
        let width = textfield.intrinsicContentSize.width
        let height = textfield.intrinsicContentSize.height
        
        textfield.frame = CGRect(x: x - width/2 , y: y , width: width + 8, height: height + 4)
        textfield.textAlignment = .center
        textfield.isUserInteractionEnabled = true
        PickedImage.addSubview(textfield)
        
        let triangleHeight = CGFloat(10)
        let triangleWidth = CGFloat(15)

        let path = UIBezierPath()
        let Layer = CAShapeLayer()
        let topYValue = textfield.bounds.origin.y
        let middleXValue = textfield.bounds.midX
        
        
        //top
        path.move(to: CGPoint(x: middleXValue, y: topYValue - triangleHeight))
        
        //bottom left
        path.addLine(to: CGPoint(x: middleXValue - triangleWidth/2, y: topYValue))
        
        //bottom right
        path.addLine(to: CGPoint(x: middleXValue + triangleWidth/2, y: topYValue))
        
        path.close()

        Layer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        Layer.frame = textfield.bounds
        Layer.path = path.cgPath
        textfield.layer.addSublayer(Layer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        tap.numberOfTapsRequired = 2
        textfield.addGestureRecognizer(tap)
        
        }

    @objc func doubleTapped(_ sender: UITapGestureRecognizer) {
        print("deleted")
        sender.view?.removeFromSuperview()
    }
    
    @objc func dismissPage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func NextPage() {
       for case let tag as DraggableView in PickedImage.subviews {
        guard let name = tag.name else {return}
        guard let uid = tag.uid else {return}
        let width = PickedImage.frame.width 
        let height = PickedImage.frame.height

        print(name,uid,width,height)
            for case let arrow in tag.subviews {
                if let frame = arrow.superview?.convert(PickedImage.frame, to: nil) {
                    print(frame)
                }

            }
        }
    }
    
    func setupView() {
        view.addSubview(PickedImage)
        
        PickedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        PickedImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        PickedImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        PickedImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.present(picker, animated: true, completion: nil)
    }
    
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           var selectedImageFromPicker: UIImage?
           
           if let originalImage = info[.originalImage] as? UIImage{
               selectedImageFromPicker = originalImage
               }
           if let selectedImage = selectedImageFromPicker {
            PickedImage.image = selectedImage
           }
           dismiss(animated: true, completion: nil)
           }
    
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }

}

class DraggableView: UITextField {
    
    var uid: String?
    var name: String?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // unwrap superview and touch
        guard let sv = superview,
            let touch = touches.first
        else { return }
        
        let parentFrame = sv.bounds
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        // new frame for this "draggable" subview, based on touch offset when moving
        var newFrame = self.frame.offsetBy(dx: location.x - previousLocation.x, dy: location.y - previousLocation.y)
        
        // make sure Left edge is not past Left edge of superview
        newFrame.origin.x = max(newFrame.origin.x, 0.0)
        // make sure Right edge is not past Right edge of superview
        newFrame.origin.x = min(newFrame.origin.x, parentFrame.size.width - newFrame.size.width)

        // make sure Top edge is not past Top edge of superview
        newFrame.origin.y = max(newFrame.origin.y, 0.0)
        // make sure Bottom edge is not past Bottom edge of superview
        newFrame.origin.y = min(newFrame.origin.y, parentFrame.size.height - newFrame.size.height)
        
        self.frame = newFrame
        
    }
    

}


class TagClass {
    
    var x: CGFloat?
    var y: CGFloat?
    var imageWidth: Double?
    var imageHeight: Double?
    var uid: String?
    var name: String?
    var xPercentage: Double?
    var yPercentage: Double?
    
}
