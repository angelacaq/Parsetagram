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
    @IBOutlet weak var profilePhotoImageView: PFImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var post:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionLabel.text = post["caption"] as? String
        photoView.file = post["media"] as? PFFile
        
        let date = post.updatedAt
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        timestampLabel.text = dateFormatter.stringFromDate(date!)
        
        let user =  post["author"] as? PFUser
        let username: String? = user!.username
        usernameLabel.text = username
        
        let likes = post["likesCount"]
        likeCountLabel.text = String(likes)
        
        profilePhotoImageView.file = user!["profilePhoto"] as? PFFile
        profilePhotoImageView.loadInBackground()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLikeButtonPressed(sender: AnyObject) {
        post["likesCount"] = (post["likesCount"] as! Int) + 1
        print(post["likesCount"])
        post.saveInBackground()
        
        let likes = post["likesCount"]
        likeCountLabel.text = String(likes)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userSegue" {
            let postData = post
            
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = postData["author"] as? PFUser
        }
    }
    
}
