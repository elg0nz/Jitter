//
//  ComposerViewController.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/1/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController {
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)

    @IBOutlet weak var textView: UITextView!
    @IBAction func onTweetButton(_ sender: Any) {
        TwitterClient.sharedInstance.createUpdate(
            text: textView.text,
            success: {
                self.dismiss(animated: true, completion: nil)
            },
            failure: { (error: Error) in
                self.alertController.message = "Could not post update"
                self.present(self.alertController, animated: true)
            }
        )
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
        alertController.addAction(OKAction)
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
