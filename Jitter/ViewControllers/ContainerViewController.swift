//
//  ContainerViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/5/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UITableViewDataSource {
    // MARK: - Outlets

    @IBOutlet weak var menuTableView: UITableView!
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
                menuTableView.reloadData()
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
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
            menuTableView?.reloadData()
        }
    }

    var contentViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            contentView.addSubview(contentViewController.view)
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        // FIXME: use a reusable cell.
        let cell = UITableViewCell()
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewControllers[indexPath.row].title
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        if viewControllerArray.count > 0 {
            contentViewController = viewControllerArray.first
        }
    }

    private func setRootViewController() {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
