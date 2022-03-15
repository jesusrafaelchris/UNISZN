//
//  InputContainerView.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 11/08/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import Foundation
import UIKit

class InputAccessoryView: UIView, UITextViewDelegate {
    
    weak var messagelog: MessageLog? {
        didSet {
            sendButton.addTarget(messagelog, action: #selector(MessageLog.sendMessage), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: messagelog, action: #selector(MessageLog.handleImagePicker)))
        }
    }
    
    lazy var Textbox: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = .black
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.isScrollEnabled = true
        textview.returnKeyType = .send
        textview.delegate = self
        textview.isUserInteractionEnabled = true
        textview.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        textview.layer.cornerRadius = 15
        textview.layer.masksToBounds = true
        return textview
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(systemName: "photo.on.rectangle.fill")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.contentMode = .scaleAspectFit
        return uploadImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
        
    var seperatorlinetopanchor:NSLayoutConstraint?
    let sendButton = UIButton(type: .system)
    
    func setupViews() {
       backgroundColor = .white
       
       addSubview(uploadImageView)
       addSubview(self.Textbox)
     //  addSubview(sendButton)
       addSubview(placeholderLabel)
       //x,y,w,h
        
      self.Textbox.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
      self.Textbox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
      self.Textbox.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
      self.Textbox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
    
      self.placeholderLabel.centerYAnchor.constraint(equalTo: Textbox.centerYAnchor).isActive = true
      self.placeholderLabel.leftAnchor.constraint(equalTo: Textbox.leftAnchor, constant: 5).isActive = true
        
       uploadImageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -10).isActive = true
       uploadImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
       uploadImageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -2).isActive = true
       
       
        let mediumConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let arrow = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: mediumConfiguration)
        //let blackflag = flag?.withTintColor(.black, renderingMode: .alwaysOriginal)
       sendButton.setImage(arrow, for: .normal)
       sendButton.translatesAutoresizingMaskIntoConstraints = false
       
       //what is handleSend?
    
       //x,y,w,h
      // sendButton.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor).isActive = true
       //sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     //  sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
      // sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    //    sendButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
       
 
        
       let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
       separatorLineView.translatesAutoresizingMaskIntoConstraints = false
       addSubview(separatorLineView)
       //x,y,w,h
       separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
       separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
       separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
       separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
       
       //textfield constraints
        

       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        Textbox.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            messagelog?.sendMessage()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
      self.invalidateIntrinsicContentSize()
        if textView.text == "\n" {
            textView.text = nil
        }
      let newAlpha: CGFloat = textView.text.isEmpty ? 1 : 0
        if placeholderLabel.alpha != newAlpha {
        UIView.animate(withDuration: 0.01) {
            self.placeholderLabel.alpha = newAlpha
        }
      }
        let size = CGSize(width: self.frame.width * 0.7, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = self.Textbox.sizeThatFits(CGSize(width: self.Textbox.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: textSize.height)
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


