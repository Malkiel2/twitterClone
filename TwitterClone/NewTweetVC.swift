//
//  NewTweetVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 11.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewTweetVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    

    @IBOutlet weak var newTweetToolbar: UIToolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitalValue = CGFloat()
    
    @IBOutlet weak var textView: UITextView!
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newTweetToolbar.isHidden = true

        self.loggedInUser = FIRAuth.auth()?.currentUser
        textView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        
        textView.delegate = self
        textView.text = "What's Happening"
        textView.textColor = UIColor.lightGray
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableKeyboardHideOnTap()
        self.toolbarBottomConstraintInitalValue = toolbarBottomConstraint.constant
    }
    
    private func enableKeyboardHideOnTap() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification: )), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification: )), name: .UIKeyboardDidHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyboardFrame: CGRect = (info![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) { 
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            self.newTweetToolbar.isHidden = false
            self.view.layoutIfNeeded()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.toolbarBottomConstraint.constant = self.toolbarBottomConstraintInitalValue
            self.newTweetToolbar.isHidden = true
            self.view.layoutIfNeeded()
        }
        
    }
    
    func hideKeyboard() {
        
        self.view.endEditing(true)
        
    }

    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    @IBAction func didTapTweet(_ sender: Any) {
        
        if textView.text.characters.count > 0 {
            let key = self.databaseRef.child("tweets").childByAutoId().key
            
            let tweet: Dictionary<String, String> = [
                "text": textView.text,
                "timestamp": NSDate().timeIntervalSince1970.description
            ]
            
            self.databaseRef.child("tweets").child((self.loggedInUser?.uid)!).child(key).updateChildValues(tweet)
            
            dismiss(animated: true, completion: nil)
            
            //let childUpdates = ["/tweets/\(self.loggedInUser?.uid)/"]
        }
        
    }
    
}
