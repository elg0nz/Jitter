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
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel! // TODO: Rename to avoid confusion
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    @IBAction func onRetweetButton(_ sender: Any) {
        print("retweet")
    }
    @IBAction func onReplyButton(_ sender: Any) {
        print("reply")
    }

    @IBAction func onHeartButton(_ sender: Any) {
        print("heart")
    }

    func loadData(tweet: Tweet) {
        tweetBodyLabel.text = tweet.text ?? ""
        retweetLabel.text = ""
        hoursAgoLabel.text = "?h"
        if let user = tweet.user {
            userImageView.setImageWith(user.profileUrl!)
            userNameLabel.text = user.screenname
            fullNameLabel.text = user.name
        }
        hoursAgoLabel.text = tweet.timestamp?.timeAgo()
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
