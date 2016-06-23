//
//  DetailsViewController.swift
//  parsetagram
//
//  Created by Angela Chen on 6/22/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionLabel.text = post["caption"] as? String
        photoView.file = post["media"] as? PFFile
        photoView.loadInBackground()
        
        let date = post.updatedAt
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        timestampLabel.text = dateFormatter.stringFromDate(date!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
