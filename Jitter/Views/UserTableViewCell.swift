//
//  UserTableViewCell.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/8/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import UIKit
import AFNetworking

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var backgroundImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
