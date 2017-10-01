//
//  TweetDetailViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/1/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import MBProgressHUD

@objc protocol TweetDetailViewControllerDelegate {
    @objc optional func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweet: Tweet)
}

class TweetDetailViewController: UIViewController {
    weak var delegate: TweetDetailViewControllerDelegate?
    var tweet: Tweet?
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel! // TODO: Rename to avoid confusion
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    @IBAction func onReplyButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        guard let tweet = self.tweet, tweet.id != nil else {
            self.alertController.message = "Could not find tweet"
            self.present(self.alertController, animated: true)
            return
        }

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Retweeting..."
        TwitterClient.sharedInstance.retweet(id: tweet.id!, success: { (tweet: Tweet) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismiss(animated: true, completion: nil)
        }) { (error: Error) in
            print(error.localizedDescription)
            self.alertController.message = "Error retweeting"
            self.present(self.alertController, animated: true)
        }
    }

    @IBAction func onHeartButton(_ sender: Any) {
        guard let tweet = self.tweet, tweet.id != nil else {
            self.alertController.message = "Could not find tweet"
            self.present(self.alertController, animated: true)
            return
        }

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Hearting..."
        TwitterClient.sharedInstance.fave(id: tweet.id!, success: { (tweet: Tweet) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismiss(animated: true, completion: nil)
        }) { (error: Error) in
            print(error.localizedDescription)
            self.alertController.message = "Error hearting tweet"
            self.present(self.alertController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
