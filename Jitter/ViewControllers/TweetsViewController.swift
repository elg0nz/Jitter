//
//  TweetsViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/30/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource {
    var tweets: [Tweet]!
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

    // MARK: - Refreshcontrol
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.reloadHomeTweets()
        refreshControl.endRefreshing()
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
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
        alertController.addAction(OKAction)
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 125
        self.reloadHomeTweets()
        setRefreshControl()
        setAlertView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
