//
//  HandleVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 10.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HandleVC: UIViewController {
    
    
    @IBOutlet weak var startTweeting: UIBarButtonItem!
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var handle: UITextField!
    
    var user: AnyObject?
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = FIRAuth.auth()?.currentUser
        
    }
    
    
    @IBAction func didTapStartTweeting(_ sender: Any) {
        
        let handle = self.rootRef.child("handles").child(self.handle.text!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if !snapshot.exists() {
                // update the handle in the user_profiles and in the handles node
                self.rootRef.child("user_profiles").child((self.user?.uid)!).child("handle").setValue(self.handle.text?.lowercased())
                
                //update the name of the user
                self.rootRef.child("user_profiles").child((self.user?.uid!)!).child("name").setValue(self.fullName.text)
                
                
                //update the handle in the handle node
                self.rootRef.child("handles").child(self.handle.text!.lowercased()).setValue(self.user?.uid)

                //send the user to home screen
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
            } else {
                self.errorMessage.text = "Handle Already in use"
            }
            
        }
        
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
