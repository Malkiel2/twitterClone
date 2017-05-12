//
//  HomeViewTableViewCell.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 11.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweet: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    public func configure(profilePic: String?, name: String, handle: String, tweet: String) {
        
        self.tweet.text = tweet
        self.handle.text = "@"+handle
        self.name.text = name
        
        if profilePic != nil {
            let imageData = NSData(contentsOf: NSURL(string: profilePic!)! as URL)
            
            self.profilePic.image = UIImage(data: imageData! as Data)
            
        } else {
            self.profilePic.image = UIImage(named: "twitter")
        }
    }

}
