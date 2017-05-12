//
//  Tweet.swift
//  TwitterClone
//
//  Created by Malkiel Shaul on 11.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import Foundation
class Tweet {
    

    private var _tweet: String!

    
    var tweet: String {
        return _tweet
    }
    
    init(tweet: String) {
        self._tweet = tweet
    }
    
}
