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

    
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
}
