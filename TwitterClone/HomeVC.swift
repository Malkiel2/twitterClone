//
//  HomeVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 11.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject?
    var loggedInUserData: AnyObject?
    
    var tweets = [AnyObject?]()
    
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        //get the logged in user details
        self.databaseRef.child("user_profiles").child((self.loggedInUser?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            //store the logged in user details into the var
            self.loggedInUserData = snapshot.value as AnyObject
            
            //get all the tweets that are made buy the user
            self.databaseRef.child("tweets").child((self.loggedInUser?.uid)!).observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in

                print("before")
                self.tweets.append(snapshot.value as AnyObject)
                
                let indexpath = [IndexPath(row: 0, section: 0)]
                
                self.tableView.insertRows(at: indexpath, with: .automatic)
                
                self.aivLoading.stopAnimating()
                
            }) {(error) in
                print("MALKI: \(error.localizedDescription)")
            }
        }

        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets.count > 0 {
            return tweets.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        
        let tweetIndex = self.tweets.count - 1 - indexPath.row
        
       //let tweet = tweets[0]!.value("text") as! String
        
        let tweet = tweets[tweetIndex]?["text"] as! String

        cell.configure(profilePic: nil, name: self.loggedInUserData?["name"] as! String, handle: self.loggedInUserData?["handle"] as! String, tweet: tweet)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    
    
}
