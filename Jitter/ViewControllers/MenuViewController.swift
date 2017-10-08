//
//  MenuViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/7/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    private var tweetsVC: UIViewController!
    private var mentionsVC: TweetsViewController!
    private var profileVC: TweetsViewController!

    var viewControllers: [UIViewController] = []
    var containerVC : ContainerViewController?

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsVC = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        tweetsVC.title = "Timeline"
        viewControllers.append(tweetsVC)
        containerVC?.contentViewController = tweetsVC

        mentionsVC = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsVC.title = "Mentions"
        mentionsVC.feedType = TwitterFeedTypes.mentions
        viewControllers.append(mentionsVC)

        profileVC = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        profileVC.title = "Profile"
        profileVC.feedType = TwitterFeedTypes.profile
        viewControllers.append(profileVC)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")

        tableView.reloadData()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        containerVC?.contentViewController = viewControllers[indexPath.row]
    }


    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewControllers[indexPath.row].title
    }
}
