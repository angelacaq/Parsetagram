//
//  PostTableViewCell.swift
//  parsetagram
//
//  Created by Angela Chen on 6/21/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import ParseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var captionLabel: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var profilePhotoImageView: PFImageView!

    
}
