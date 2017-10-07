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
private let consumerKey = "Ql8AFZCnu4WaVteVRT4TEFptU"
private let consumerSecret = "FSjjgoBKlD39DxPSZKm8P4fTT54hBZjIPuA3FfldkuYlJTIaKe"
let responseCache = NSCache<NSString, AnyObject>()

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance: TwitterClient = TwitterClient(
        baseURL: URL(string: baseApiURL)!,
        consumerKey: consumerKey,
        consumerSecret: consumerSecret
    )

    var loginSuccess: (() -> Void)?
    var loginFailure: ((Error) -> Void)?

    // MARK: - Authentication
    func login(success: @escaping ()-> Void, failure: @escaping (Error) -> Void) {
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
            success: { (_: BDBOAuth1Credential!) -> Void in
                self.currentAccount(
                    success: { (user: User) in
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
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (NSError) -> Void) {
        let PAGE_SIZE = 20

        // TODO: Come up with a more generic way to cache. Maybe by overriding BDBOAuth1SessionManager.get
        if let cachedVersion = responseCache.object(forKey: "homeTimeline") {
            var tweets = Tweet.tweetsWithArray(dictionaries: cachedVersion as! [NSDictionary])
            tweets.sort()
            success(Array(tweets.prefix(PAGE_SIZE)))
        } else {
            TwitterClient.sharedInstance.get(
                "1.1/statuses/home_timeline.json",
                parameters: nil,
                progress: nil,
                success: { (urlSessionTask: URLSessionTask, result: Any?) in
                    let tweetsDictionary = result as! [NSDictionary]
                    responseCache.setObject(tweetsDictionary as AnyObject, forKey: "homeTimeline")
                    var tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
                    tweets.sort()
                    success(Array(tweets.prefix(PAGE_SIZE)))
                    let five_minutes = 5 * 60
                    Timer.scheduledTimer(timeInterval: TimeInterval(five_minutes), target: self, selector: #selector(self.clearCache), userInfo: ["key": "homeTimeline"], repeats: false)
            },
                failure: { (_: URLSessionTask?, error: Error) in
                    failure(error as NSError)
            })
        }
    }

    @objc func clearCache(timer: Timer) {
        let info = timer.userInfo as! Dictionary<String, String>?
        if let key = info?["key"] {
            responseCache.removeObject(forKey: key as NSString)
        }
    }

    func currentAccount(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (urlSessionTask: URLSessionTask, result: Any?) in
                let credentials = result as! NSDictionary
                let user = User(dictionary: credentials)
                success(user)
        },
            failure: { (_: URLSessionTask?, error: Error) in
                failure(error)
        })
    }

    func createUpdate(text: String, in_reply_to: Int64?, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        var parameters: [String: String] = ["status": text]
        if let reply_id = in_reply_to {
            parameters = [
                "status": text,
                "in_reply_to_status_id": String(reply_id)
            ]
        }

        self.post(
            "1.1/statuses/update.json",
            parameters: parameters,
            progress: nil,
            success: { (task: URLSessionDataTask, _: Any?) in
                success()
            },
            failure: { (_: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
                failure(error)
            }
        )
    }

    func fave(id: Int64, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        let stringId = String(id)
        let parameters: [String: String] = ["id": stringId]
        self.post(
            "1.1/favorites/create.json",
            parameters: parameters,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                tweet.favorited = true
                success(tweet)
            },
            failure: { (_: URLSessionDataTask?, error: Error) -> Void in
                print(error.localizedDescription)
                failure(error)
            }
        )
    }

    func retweet(id: Int64, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        let stringId = String(id)
        self.post(
            "1.1/statuses/retweet/\(stringId).json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                tweet.favorited = true
                success(tweet)
        },
            failure: { (_: URLSessionDataTask?, error: Error) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
        )
    }
}
