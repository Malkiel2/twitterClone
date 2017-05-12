//
//  SignUpVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 10.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    var databaseRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var signUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUp.isEnabled = false
    }
    
    
    @IBAction func textDidChanged(_ sender: UITextField) {
        
        if (email.text?.characters.count)! > 0 , (password.text?.characters.count)! > 0 {
            
            signUp.isEnabled = true
            
        } else {
            signUp.isEnabled = false
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func didTapSignUp(_ sender: Any) {
        
        signUp.isEnabled = false
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            if error != nil {
                self.errorMessage.text = error?.localizedDescription
                return
            }
            
            self.errorMessage.text = "Registerd Succesfully"
            
            FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                
                if error != nil {
                    self.errorMessage.text = error?.localizedDescription
                    return
                }
                
                self.databaseRef.child("user_profiles").child((user?.uid)!).child("email").setValue(self.email.text)
                
                self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                
            })
            
        })
        
    }
    
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
