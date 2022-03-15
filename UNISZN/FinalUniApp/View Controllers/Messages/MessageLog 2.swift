//
//  MessageLog.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 10/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Kingfisher

class MessageLog: UICollectionViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let Textbox: UITextField = {
        let TextField = UITextField()
        TextField.placeholder = "Send Message..."
        TextField.translatesAutoresizingMaskIntoConstraints = false
        return TextField
    }()

    let docRef = Firestore.firestore()
    var username: String?
    var id: String?
    var messages = [messageInfo]()
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard  let cv = collectionView else {
            return
        }
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false

        cv.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(cv)
        
        
        Textbox.delegate = self
        collectionView.alwaysBounceVertical = true
        observeMessages()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        collectionView.keyboardDismissMode = .interactive
        setupKeyboardObservers()
        collectionView.isPrefetchingEnabled = false //Watch out for this one

        
    }
    
    var seperatorlinetopanchor:NSLayoutConstraint?
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        let uploadimageview = UIImageView()
        uploadimageview.isUserInteractionEnabled = true
        uploadimageview.image = UIImage(systemName: "rectangle.on.rectangle.angled")?.withTintColor(.gray)
        uploadimageview.translatesAutoresizingMaskIntoConstraints = false
        uploadimageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
        containerView.addSubview(uploadimageview)
        
        // uploadimageview constraints
        
        uploadimageview.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 4).isActive = true
        uploadimageview.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadimageview.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadimageview.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        //sendbutton constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.Textbox)
        
        //textfield constraints
        
        self.Textbox.leftAnchor.constraint(equalTo: uploadimageview.rightAnchor,constant: 8).isActive = true
        self.Textbox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.Textbox.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.Textbox.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        //line constraints
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorlinetopanchor = seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor)
        seperatorlinetopanchor?.isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        return containerView
        
    }()
    
    @objc func handleImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage{
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
           
            uploadImageToFirebase(selectedImage)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadImageToFirebase(_ image: UIImage) {
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploaddata = image.jpegData(compressionQuality: 1) {
            ref.putData(uploaddata, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error?.localizedDescription as! String)
                    return
                }
                else {
            ref.downloadURL { (url, error) in
               if error != nil {
                print(error?.localizedDescription as! String)
                return
               }
               guard let urlString = url?.absoluteString else{return}
                
                self.sendMessageWithImageUrl(urlString, image)
                    }
                }
            }
        }
    }
    
    private func sendMessageWithImageUrl(_ imageUrl: String,_ image: UIImage) {
        
        let fromID = Auth.auth().currentUser?.uid
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        guard let toID = self.id else {return}
        let document = self.docRef.collection("messages").document()
        let DocID = document.documentID
        document.setData([
            "imageUrl": imageUrl,
            "TimeStamp": timestamp,
            "FromID": fromID as Any,
            "ToID": self.id!,
            "imageWidth": image.size.width ,
            "imageHeight": image.size.height ]) {
        err in
           if let err = err {
               print("Error writing document: \(err)")
           } else {
               print("Document successfully written!")
            self.Textbox.text = nil
            let ref = Firestore.firestore().collection("user-messages").document(fromID!).collection(fromID!).document(toID)
            ref.setData([DocID: 1], merge: true)
            
            let recipientUserMessagesRef = Firestore.firestore().collection("user-messages").document(toID).collection(toID).document(fromID!)
            recipientUserMessagesRef.setData([DocID: 1], merge: true)
            
                }
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
        let indexPath = NSIndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue)!

        containerViewbottomAnchor?.constant = -keyboardFrame!.height

        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let duration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue)!
         
         containerViewbottomAnchor?.constant = 0
         
        
         UIView.animate(withDuration: duration) {
             self.view.layoutIfNeeded()
         }
    }
    
    var containerViewbottomAnchor: NSLayoutConstraint?

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.username
        self.view.layoutIfNeeded()
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessagesRef = Firestore.firestore().collection("user-messages").document(uid).collection(uid).document(self.id!)
        
        let listener = userMessagesRef.addSnapshotListener { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else {
                
                guard let data = snapshot?.data() else {return}
                let keydict = data.keys
                var stringArray = Array(keydict)
                self.messages.removeAll()
                for message in stringArray {
                let messagesRef = Firestore.firestore().collection("messages").document(message)
                let listener = messagesRef.addSnapshotListener { (snapshot, error) in
                if let error = error{
                   print(error.localizedDescription)
              }
               else {
                
                guard let dictionary = snapshot?.data() as [String:AnyObject]? else {return}
                
                let message = messageInfo(dictionary: dictionary)
                
                if message.chatPartner() == self.id {
                   self.messages.append(message)
                   self.messages.sort { (message1, message2) -> Bool in
                   return (message2.TimeStamp!.intValue) > message1.TimeStamp!.intValue
                    }
                 
              DispatchQueue.main.async {
                self.collectionView.reloadData()
                //scroll to last index
                let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
}
}
    
    }
    
      
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    
    @IBAction func SendMessageButton(_ sender: Any) {
        sendMessage()
    }
    
@objc func sendMessage() {
        let fromID = Auth.auth().currentUser?.uid
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        guard let toID = self.id else {return}
        let document = self.docRef.collection("messages").document()
        let DocID = document.documentID
        document.setData([
            "Text": self.Textbox.text!,
            "TimeStamp": timestamp,
            "FromID": fromID as Any,
            "ToID": self.id!]) {
        err in
           if let err = err {
               print("Error writing document: \(err)")
           } else {
               print("Document successfully written!")
            self.Textbox.text = nil
            let ref = Firestore.firestore().collection("user-messages").document(fromID!).collection(fromID!).document(toID)
            ref.setData([DocID: 1], merge: true)
            
            let recipientUserMessagesRef = Firestore.firestore().collection("user-messages").document(toID).collection(toID).document(fromID!)
            recipientUserMessagesRef.setData([DocID: 1], merge: true)
            
                }
            }
        }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImage: UIImageView?
    
    func performZoomForStartingImageView(_ startingImage: UIImageView) {

        self.startingImage = startingImage
        self.startingImage?.isHidden = true
        startingFrame = startingImage.superview?.convert(startingImage.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImage.image
        zoomingImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomOut))
        tapGestureRecognizer.numberOfTapsRequired = 1
        zoomingImageView.addGestureRecognizer(tapGestureRecognizer)
        self.Textbox.resignFirstResponder()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.backgroundColor = .black
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackBackgroundView?.alpha = 1
            self.inputContainerView.alpha = 0
            
                let height = (self.startingFrame!.height / self.startingFrame!.width) * keyWindow.frame.width
                
            zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            
            zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
            
            
            
        }
        
    }
    
    @objc func zoomOut(tap: UITapGestureRecognizer) {
        if let zoomOutImageView = tap.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }) { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImage?.isHidden = false
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        
        cell.MessageLog = self
        
        let message = messages[indexPath.item] 
        cell.textView.text = message.Text
        
        DispatchQueue.main.async {
            self.setUpCell(cell: cell, message: message)
        }
        if let text = message.Text {
            //text
            cell.textView.isHidden = false
             cell.bubbleWidthAnchor?.constant = EstimatedFrame(text: text).width + 25
        } else if message.imageUrl != nil {
            // images go in here
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 200 //conflicting constraint
        }
       

        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: messageInfo) {
        guard let chatPartnerID = message.chatPartner() else {
            return
        }
        let ref = Firestore.firestore().collection("users").document(chatPartnerID)
        ref.getDocument { (snapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            if let snapshot = snapshot {
            let data = snapshot.data()
                guard let dictionary = data as [String:AnyObject]? else {return}
                let user = User()
                user.setValuesForKeys(dictionary)
                if let profileImageURL = user.ProfilePicUrl {
                    let url = URL(string: profileImageURL)
                    cell.profileImageView.kf.setImage(with: url)
                    
                }
                
        
        if message.FromID == Auth.auth().currentUser?.uid{
            //outgoing message
            cell.bubbleView.backgroundColor = .systemBlue//ChatMessageCell.lilacColour
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else {
            // incoming message
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
                
                if let messageUrl = message.imageUrl {
                    let url = URL(string: messageUrl)
                    cell.messageImageView.kf.setImage(with: url)
                    cell.messageImageView.isHidden = false
                    cell.bubbleView.backgroundColor = .clear
                } else {
                    cell.messageImageView.isHidden = true
                    
                    }
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }

}


extension MessageLog: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 80
        
        let message = messages[indexPath.item]
        
        if let text = message.Text {
            height = EstimatedFrame(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
             height = CGFloat((imageHeight/imageWidth) * 200)
        }
        
        
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func EstimatedFrame(text:String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}


