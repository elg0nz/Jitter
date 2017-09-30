//
//  TwitterClient.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseApiURL = "https://api.twitter.com"
private let consumerKey = "KZ8xWPOiKDr4uapnr3eDGHe24"
private let consumerSecret = "O9HxZSnrZ50DNoH80Ss0rHQBDsmjgwKuIyrm8hIIIBGrrFSfJy"

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance: TwitterClient = TwitterClient(
        baseURL: URL(string: baseApiURL)!,
        consumerKey: consumerKey,
        consumerSecret: consumerSecret
    )
}
