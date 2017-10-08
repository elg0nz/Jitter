//
//  TweetsViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

enum TwitterFeedTypes {
    case home
    case mentions
    case profile
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets: [Tweet]!
    public var feedType: TwitterFeedTypes = .home
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)

    @IBOutlet weak var tweetsTableView: UITableView!
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
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
        if feedType == .profile {
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
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
        if feedType == .profile {
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
