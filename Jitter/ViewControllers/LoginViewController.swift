//
//  LoginViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 9/26/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance.deauthorize() // TODO: Is this still necessary?
        TwitterClient.sharedInstance.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "jitter://oauth/callback"),
            scope: nil,
            success: requestTokenSuccess,
            failure: requestTokenFailure
        )
    }
    private func requestTokenSuccess(requestToken: BDBOAuth1Credential!) {
        let url = URL(string: "\(baseApiURL)/oauth/authorize?oauth_token=\(requestToken.token!)")
        UIApplication.shared.open(url!, options: [:], completionHandler: openedTokenUrl)
    }

    private func openedTokenUrl(success: Bool) -> Void{
        if success == false {
            print("Error fetching access token")
            return
        }
    }

    private func requestTokenFailure(error: Error!) {
        print(error)
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
