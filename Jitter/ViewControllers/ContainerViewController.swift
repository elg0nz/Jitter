//
//  ContainerViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/5/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var originalLeftMargin: CGFloat!

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
