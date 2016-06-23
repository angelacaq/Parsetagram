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
        if let posts = posts {
            return posts.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        
        if let posts = posts {
            
            let postData = posts[indexPath.row]
            
            cell.photoView.file = postData["media"] as? PFFile
            cell.photoView.loadInBackground()
            cell.captionLabel.text = postData["caption"] as? String
            
            cell.usernameLabel.text = postData["author"] as? String
            
            let user = postData["author"] as? PFUser
            let username: String? = user!.username
            cell.usernameLabel.text = username
        }
        return cell
    }
    
    func updateQuery(refreshControl: UIRefreshControl? = nil) {
        let query = PFQuery(className: "Post")
        
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = queryLimit

        print(query.limit)
        
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) -> Void in
            if let data = data {
                let temp = self.posts?.count
                self.posts = data
                
                if (temp < data.count) {
                    print(temp)
                    print(data.count)
                    self.queryLimit += 20
                }
                
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                
                self.tableView.reloadData()
                
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
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
        if segue.identifier != "logoutSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let postData = posts![indexPath!.row]
        
            cell.selectionStyle = .None
        
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.post = postData
        }        
    }
    

}
