//
//  User.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var profileBackgroundImage: URL?
    var tweetsCount: Int = 0
    var followersCount: Int = 0
    var followingCount: Int = 0

    private var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        if let dictName = dictionary["name"] as? String {
            name = dictName
        }
        if let nick = dictionary["screen_name"] as? String {
            screenname = "@\(nick)"
        }
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
        let profileBackgroundUrlString = dictionary["profile_banner_url"] as? String
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundImage = URL(string: profileBackgroundUrlString)
        }
        tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
    }

    static private var _currentUser: User?
    static let userDidLogoutNotificationName = NSNotification.Name(rawValue: "userDidLogout")
    static let userProfileTapNotificationName = NSNotification.Name(rawValue: "profileTap")

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
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()

        }
    }
}
