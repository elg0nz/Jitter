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
        let cell = UITableViewCell()
        cell.textLabel?.text = tweet.description
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.dataSource = self
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
