//
//  ViewController.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 10.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let currentUser = user {
                print("Malki: User is signed in")
                
                //sent the user to the HomeVC
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let homeVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarControllerView")
                
                //send the user to the home screen
                self.present(homeVC, animated: true, completion: nil)
                
                
            }
            
            
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

