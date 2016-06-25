//
//  HomeViewController.swift
//  parsetagram
//
//  Created by Angela Chen on 6/20/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var posts:[PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var queryLimit = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateQuery()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateQuery(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // for infinite scroll 
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width,InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                updateQuery()
            }
        }
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("logoutSegue", sender: self)
                print("User logged out successfully")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            return 1 //return posts.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        
        if let posts = posts {
            
            let postData = posts[indexPath.section]
            
            cell.photoView.file = postData["media"] as? PFFile
            cell.photoView.loadInBackground()
            
            cell.captionLabel.text = postData["caption"] as? String
            
            cell.likeButton.tag = indexPath.section
            
            let likes = postData["likesCount"]
            if likes as! Int == 1 {
                cell.likeLabel.text = String("\(likes) like")
            } else {
                cell.likeLabel.text = String("\(likes) likes")
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let header = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell
        
        if let posts = posts {
            print(section)
            
            let postData = posts[section]
            
            let user =  postData["author"] as? PFUser
            let username: String? = user!.username
            
            header.usernameLabel.text = username
            
            let date = postData.updatedAt
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            header.timestampLabel.text = dateFormatter.stringFromDate(date!)
            
            header.usernameButton.tag = section
            
            header.profilePhotoImageView.file = user!["profilePhoto"] as? PFFile
            header.profilePhotoImageView.loadInBackground()
            
        }
        
        return header
    }
    
    @IBAction func onLikedButton(sender: AnyObject) {
        let button = sender as! UIButton
  
        let postData = posts![button.tag]
        postData["likesCount"] = (postData["likesCount"] as! Int) + 1
        postData.saveInBackground()
        
        tableView.reloadData()
        //let likes = postData["likesCount"]
        //self.likeLabel.text = String("\(likes) likes")
        
    }
    
    func updateQuery(refreshControl: UIRefreshControl? = nil) {
        let query = PFQuery(className: "Post")
        
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = queryLimit
        
        if refreshControl == nil && !isMoreDataLoading {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) -> Void in
            if let data = data {
                let temp = self.posts?.count
                self.posts = data
                
                if (data.count == self.queryLimit && temp < data.count && refreshControl == nil) {
                    self.queryLimit += 20
                }
                
                self.tableView.reloadData()
                
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
                } else if (self.isMoreDataLoading) {
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                } else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let postData = posts![indexPath!.section]
            
            cell.selectionStyle = .None
        
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.post = postData
        } else if segue.identifier == "userSegue" {
            let button = sender as! UIButton
            let postData = posts![button.tag]
            
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = postData["author"] as? PFUser
        }
    }
    

}
