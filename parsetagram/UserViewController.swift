//
//  UserViewController.swift
//  parsetagram
//
//  Created by Angela Chen on 6/20/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDelegate {
    
    var user: PFUser!
    var posts:[PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var queryLimit = 12

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var profilePhoto: PFImageView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = PFUser.currentUser()
        }
        
        let username: String? = user!.username
        usernameLabel.text = username
        
        profilePhoto.file = user["profilePhoto"] as? PFFile
        profilePhoto.loadInBackground()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        updateQuery()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateQuery(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        // for infinite scroll
        let frame = CGRectMake(0, collectionView.contentSize.height, collectionView.bounds.size.width,InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        collectionView.addSubview(loadingMoreView!)
        
        var insets = collectionView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView.contentInset = insets
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 3
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditButtonPressed(sender: AnyObject) {
        if user == PFUser.currentUser() {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        //editPhotoButton.setBackgroundImage(editedImage, forState: .Normal)
        
        let imageFile = Post.getPFFileFromImage(editedImage)
        user["profilePhoto"] = imageFile
        user.saveInBackground()
        
        profilePhoto.image = editedImage
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateQuery(refreshControl: UIRefreshControl? = nil) {
        let query = PFQuery(className: "Post")
        
        query.orderByDescending("createdAt")
        query.includeKey("author")
        
        query.limit = queryLimit
        query.whereKey("author", equalTo: user)
        
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) -> Void in
            if let data = data {
                print("yes hello")
                let temp = self.posts?.count
                self.posts = data
                
                if (data.count == self.queryLimit && temp < data.count && refreshControl == nil) {
                    self.queryLimit += 12
                }
                
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                
                self.collectionView.reloadData()
                
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.dragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, collectionView.contentSize.height, collectionView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                updateQuery()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let postData = posts![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.post = postData

        }

    }
 

}

extension UserViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserImagesCell", forIndexPath: indexPath) as! UserImagesCell
        
        if let posts = posts {
            let postData = posts[indexPath.row]
            
            cell.postImage.file = postData["media"] as? PFFile
            cell.postImage.loadInBackground()
        }
        
        return cell
    }

}

