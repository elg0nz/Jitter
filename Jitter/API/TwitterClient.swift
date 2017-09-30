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

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        TwitterClient.sharedInstance.get(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (urlSessionTask: URLSessionTask, result: Any?) in
                let tweetsDictionary = result as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
                success(tweets)
        },
            failure: { (urlSessionTask: URLSessionTask?, error: Error) in
                failure(error as NSError)
        })
    }

    func currentAccount() {
        get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (urlSessionTask: URLSessionTask, result: Any?) in
                let credentials = result as! NSDictionary
                let user = User(dictionary: credentials)
                print("name: \(user.name!)")
                print("profile url \(user.profileUrl!)")
        },
            failure: { (urlSessionTask: URLSessionTask?, error: Error) in
                print(error)
        })
    }
}
