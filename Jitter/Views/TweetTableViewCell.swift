//
//  TweetTableViewCell.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/1/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet?
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel! // TODO: Rename to avoid confusion
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!

    func loadData(tweet: Tweet) {
        self.tweet = tweet
        tweetBodyLabel.text = tweet.text ?? ""
        retweetLabel.text = ""
        hoursAgoLabel.text = "?h"
        if let user = tweet.user {
            userImageView.setImageWith(user.profileUrl!)
            userNameLabel.text = user.screenname
            fullNameLabel.text = user.name
            self.userImageView.layer.cornerRadius = 10
            self.userImageView.clipsToBounds = true
        }
        hoursAgoLabel.text = tweet.timestamp?.timeAgo()
        replyCount.text = String(tweet.replyCount)
        retweetCount.text = String(tweet.retweetCount)
        likeCount.text = String(tweet.favoritesCount)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        singleTap.numberOfTapsRequired = 1
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(singleTap)
    }

    @objc func imageTap(_ sender: UITapGestureRecognizer) {
        if let user = self.tweet?.user {
            let userInfo = ["user": user]
            NotificationCenter.default.post(name: User.userProfileTapNotificationName, object: nil, userInfo: userInfo)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
