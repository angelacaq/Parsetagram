//
//  CameraViewController.swift
//  parsetagram
//
//  Created by Angela Chen on 6/20/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionButton: UIButton!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionView.hidden = true
        captionButton.hidden = true
        navButton.hidden = true
        
        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(animated: Bool) {
        // create object
        captureSession = AVCaptureSession()
        
        // configure HQ session
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        photoView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        captionButton.hidden = false
        navButton.hidden = false
    }
    
    @IBAction func onCameraPressed(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func onCaptionPressed(sender: AnyObject) {
        captionView.hidden = false
    }
    
    @IBAction func onCaptionXPressed(sender: AnyObject) {
        captionView.hidden = true
        view.endEditing(true)
    }
    
    @IBAction func onNavButtonPressed(sender: AnyObject) {
        Post.postUserImage(photoView.image, withCaption: captionTextView.text, withCompletion: nil)
        print("Posted user image!")
        
        view.reloadInputViews()
        captionView.hidden = true
        captionTextView.text = ""
        captionButton.hidden = true
        photoView.image = nil
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
