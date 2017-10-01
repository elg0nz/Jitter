//
//  User.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?

    private var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? NSString
    }

    static private var _currentUser: User?
    static let userDidLogoutNotificationName = NSNotification.Name(rawValue: "userDidLogout")

    class var currentUser: User? {
        get {
            if (_currentUser != nil) {
                return _currentUser
            }

            let data = UserDefaults.standard.object(forKey: "currentUserData") as? Data
            if (data != nil) {
                let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else{
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()

        }
    }
}
