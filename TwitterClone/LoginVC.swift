//
//  LoginVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 10.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var rootRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
            
            if error == nil {
                self.rootRef.child("user_profiles").child((user?.uid)!).child("handle").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    
                    
                    if !snapshot.exists() {
                        
                        //user does not have a handle
                        //send the user to the handle view
                        
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                        
                    } else {
                        //send the user to the home view
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                    
                })
            } else {
                self.errorMessage.text = error?.localizedDescription
            }
            
        })
        
    }
    
    

}
