//
//  MeVC.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 11.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import  FirebaseStorage

class MeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var about: UITextField!
    
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    var loggedInUser: AnyObject?
    var databaseRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var tweetsContainer: UIView!
    @IBOutlet weak var mediaContainer: UIView!
    @IBOutlet weak var likesContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profiles").child((self.loggedInUser?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            let dict = snapshot.value as? Dictionary<String, AnyObject>
            
            self.name.text = dict?["name"] as? String
            self.handle.text = dict?["handle"] as? String
            
            //initially the user will not have an about data
            if let about = dict?["about"] as? String {
                self.about.text = about
            }
            
            if let profilePictureURL = dict?["profile_pic"] as? String {
                let data = NSData(contentsOf: NSURL(string: profilePictureURL)! as URL)
                self.setProfilePicture(imageView: self.profilePicture, imageToSet: UIImage(data: data! as Data)!)
            }
            
        }
        
        self.tweetsContainer.alpha = 1
        self.mediaContainer.alpha = 0
        self.likesContainer.alpha = 0
        
        self.imageLoader.stopAnimating()
    }
    
    
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "welcomeVC")
        self.present(welcomeVC, animated: true, completion: nil)
    }
    
    
    
    @IBAction func showComponents(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.tweetsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
            })
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.tweetsContainer.alpha = 0
                self.mediaContainer.alpha = 1
                self.likesContainer.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.tweetsContainer.alpha = 0
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 1
            })
        }
        
    }
    
    internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage) {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    
    
    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        
        //create the action sheet
        let myActionSheet = UIAlertController(title: "Profile Piture", message: "Select", preferredStyle: .actionSheet)
        let viewPicture = UIAlertAction(title: "View Picture", style: .default) { (action) in
            
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
            
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }
        
        let photoGallery = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        //remove the larger image from the view
        sender.view?.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.imageLoader.startAnimating()
        setProfilePicture(imageView: self.profilePicture, imageToSet: info[UIImagePickerControllerEditedImage] as! UIImage)
        
        if let imageData = UIImagePNGRepresentation(self.profilePicture.image!)! as? NSData {
            
            let profilePicStorageRef = storageRef.child("user_profiles").child((self.loggedInUser?.uid)!).child("profile_pic")
            _ = profilePicStorageRef.put(imageData as Data, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    let downloadUrl = metadata?.downloadURL()
                    
                    self.databaseRef.child("user_profiles").child((self.loggedInUser?.uid)!).child("profile_pic").setValue(downloadUrl?.absoluteString)
                } else {
                    print("MALKI: \(String(describing: error?.localizedDescription))")
                }
            })

            
            self.imageLoader.stopAnimating()
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
