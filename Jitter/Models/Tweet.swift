//
//  Tweet.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class Tweet: NSObject, Comparable {
    static func <(lhs: Tweet, rhs: Tweet) -> Bool {
        if lhs.timestamp != nil && rhs.timestamp != nil {
            return lhs.timestamp! > rhs.timestamp!
        }

        return false
    }

    // TODO: Use String instead
    var text: NSString?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0

    override var description: String {
        return "\(text!) - rt \(retweetCount) - fv \(favoritesCount) \(timestamp!)"
    }

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
