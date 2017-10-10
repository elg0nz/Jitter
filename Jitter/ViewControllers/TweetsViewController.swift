//
//  TweetsViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import AFNetworking

enum TwitterFeedTypes {
    case home
    case mentions
    case profile
    case otherProfile
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets: [Tweet]!
    var screenName: String?
    var currentUser: User? = User.currentUser
    public var feedType: TwitterFeedTypes = .home
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)

    @IBOutlet weak var tweetsTableView: UITableView!
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }

    // MARK: - TableView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 12 {
            if let header = tweetsTableView.headerView(forSection: 0) {
                let headerRect = CGRect(x: 0, y: 0, width: header.frame.width, height: 0)
                header.frame = headerRect
            }
        }
    }

    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets?.count {
            return count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetTableViewCell") as! TweetTableViewCell
        cell.loadData(tweet: tweet)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if feedType == .profile || feedType == .otherProfile {
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
            if let currentUser = self.currentUser {
                cell.userName.text = currentUser.screenname
                if let fullName = currentUser.name {
                    cell.fullName.text = fullName
                } else {
                    cell.fullName.text = "WanderTap"
                }
                cell.followersCount.text = "\(currentUser.followersCount)"
                cell.followingCount.text = "\(currentUser.followingCount)"
                cell.tweetsCount.text = "\(currentUser.tweetsCount)"
                if let bgImgUrl = currentUser.profileBackgroundImage {
                    cell.backgroundImage.setImageWith(bgImgUrl)
                } else {
                    cell.backgroundImage.image = UIImage(named: "JitterBackground")
                }
                if let imgUrl = currentUser.profileUrl {
                    cell.profileImage.setImageWith(imgUrl)
                }
            }
            return cell
        }
        return nil
    }

    // MARK: - Refreshcontrol
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.reloadTweets()
        refreshControl.endRefreshing()
    }

    private func reloadTweets() {
        switch feedType {
        case .home:
            self.reloadHomeTweets()
        case .mentions:
            self.reloadMentions()
        case .profile:
            self.reloadProfile()
        case .otherProfile:
            self.reloadOtherUserProfile()
        }
    }

    private func reloadOtherUserProfile() {
        TwitterClient.sharedInstance.userActivity(screenName: screenName!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
            self.alertController.message = "Could not refresh"
            self.present(self.alertController, animated: true)
        }
    }

    private func reloadProfile() {
        TwitterClient.sharedInstance.userActivity(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
            self.alertController.message = "Could not refresh"
            self.present(self.alertController, animated: true)
        }
    }

    private func reloadMentions() {
        TwitterClient.sharedInstance.mentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
            self.alertController.message = "Could not refresh"
            self.present(self.alertController, animated: true)
        }
    }

    private func reloadHomeTweets() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
            self.alertController.message = "Could not refresh"
            self.present(self.alertController, animated: true)
        }
    }

    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
    }

    private func setAlertView() {
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in}
        alertController.addAction(OKAction)
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.estimatedRowHeight = 125
        if feedType == .profile || feedType == .otherProfile {
            tweetsTableView.estimatedSectionHeaderHeight = 225
            tweetsTableView.sectionHeaderHeight = 225
        }

        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tweetsTableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")

        self.reloadTweets()
        setRefreshControl()
        setAlertView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetail" {
            let cell = sender as! TweetTableViewCell
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! TweetDetailViewController
            destinationVC.tweet = cell.tweet
            destinationVC.delegate = self as? TweetDetailViewControllerDelegate
        }
    }
}
