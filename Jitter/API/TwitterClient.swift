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

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    // MARK: - Authentication
    func login(success: @escaping ()-> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "jitter://oauth/callback"),
            scope: nil,
            success: { (credential: BDBOAuth1Credential?) in
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential!.token as String)")
                UIApplication.shared.open(authURL!)
            },
            failure: { (error: Error!) in
                print(error!.localizedDescription)
                self.loginFailure?(error)
            }
        )
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotificationName, object: nil)
    }

    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.currentAccount(
                    success: { (user: User) in
                        print(user)
                        User.currentUser = user
                        self.loginSuccess?()
                    },
                    failure: { (error: Error) in
                        print(error.localizedDescription)
                        self.loginFailure?(error)
                    }
                )
            },
            failure: { (error: Error?) -> Void in
                print(error?.localizedDescription as Any)
                self.loginFailure?(error!)
            }
        )
    }

    // MARK: - API Calls
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

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (urlSessionTask: URLSessionTask, result: Any?) in
                let credentials = result as! NSDictionary
                let user = User(dictionary: credentials)
                success(user)
        },
            failure: { (urlSessionTask: URLSessionTask?, error: Error) in
                failure(error)
        })
    }
}
