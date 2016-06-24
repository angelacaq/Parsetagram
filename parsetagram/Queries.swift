//
//  Queries.swift
//  parsetagram
//
//  Created by Angela Chen on 6/24/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import Foundation
import UIKit
import Parse

public class Queries {
    var posts:[PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var queryLimit = 20
    
    func updateQuery(refreshControl: UIRefreshControl? = nil) {
        let query = PFQuery(className: "Post")
        
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = queryLimit
        
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) -> Void in
            if let data = data {
                let temp = self.posts?.count
                self.posts = data
                
                if (data.count == self.queryLimit && temp < data.count && refreshControl == nil) {
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
    
}