//
//  ContainerViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/5/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .ended {
            let opening = velocity.x > 0
            let openingConstant:CGFloat = view.frame.size.width / 2

            if opening {
                leftMarginConstraint.constant = view.frame.size.width - openingConstant
            } else {
                leftMarginConstraint.constant = 0
            }
        }
    }
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    // MARK: - instance variables
    var originalLeftMargin: CGFloat!
    private var viewControllerArray: [UIViewController]! = []
    var viewControllers: [UIViewController]  {
        get {
            let immutableCopy = viewControllerArray
            return immutableCopy!
        }

        set {
            viewControllerArray = newValue
        }
    }

    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()

            if oldMenuViewController != nil {
                oldMenuViewController.willMove(toParentViewController: nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMove(toParentViewController: nil)
            }

            menuView.addSubview(menuViewController.view)
        }
    }

    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()

            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }

            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)

            UIView.animate(withDuration: 0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: User.userProfileTapNotificationName,
            object: nil,
            queue: OperationQueue.main
        ) { (notification: Notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
            profileVC.feedType = TwitterFeedTypes.otherProfile
            let user = notification.userInfo!["user"] as! User 
            profileVC.screenName = user.screenname
            self.contentViewController = profileVC
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
