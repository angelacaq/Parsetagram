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
import MBProgressHUD

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionButton: UIButton!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonReplacement: UIView!
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionView.hidden = true
        captionButton.hidden = true
        navButton.hidden = true
        cancelButton.hidden = true
        buttonReplacement.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if session!.canAddOutput(stillImageOutput) {
                session!.addOutput(stillImageOutput)
                // ...
                // Configure the Live Preview here...
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                let bounds:CGRect = previewView.layer.bounds
                videoPreviewLayer!.bounds = bounds
                videoPreviewLayer!.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))

                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                previewView.contentMode = UIViewContentMode.ScaleAspectFill
                session!.startRunning()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCameraPressed(sender: AnyObject) {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    self.photoView.contentMode = UIViewContentMode.ScaleAspectFill
                    let properImage = Post.resize(image, newSize: self.photoView.bounds.size)
                    self.photoView.image = properImage
                    self.navButton.hidden = false
                    self.captionButton.hidden = false
                    self.cancelButton.hidden = false
                    self.buttonReplacement.hidden = false
                }
            })
        }
    }

    @IBAction func onCaptionPressed(sender: AnyObject) {
        captionView.hidden = false
    }
    
    @IBAction func onCaptionXPressed(sender: AnyObject) {
        captionView.hidden = true
        view.endEditing(true)
    }
    
    @IBAction func onTapRecognized(sender: AnyObject) {
        captionView.hidden = true
        view.endEditing(true)
    }
    
    @IBAction func onGridPressed(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        captionTextView.text = ""
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
     didFinishPickingMediaWithInfo info: [String : AnyObject]) {
     let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
     
     // Do something with the images (based on your use case)
     photoView.image = editedImage
     
     // Dismiss UIImagePickerController to go back to your original view controller
     dismissViewControllerAnimated(true, completion: nil)
     
     captionButton.hidden = false
     navButton.hidden = false
     cancelButton.hidden = false
     buttonReplacement.hidden = false
     }
    
    @IBAction func onNavButtonPressed(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Post.postUserImage(photoView.image, withCaption: captionTextView.text, withCompletion: nil)
        print("Posted user image!")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        view.reloadInputViews()
        captionView.hidden = true
        captionTextView.text = ""
        captionButton.hidden = true
        photoView.image = nil
        navButton.hidden = true
        cancelButton.hidden = true
        buttonReplacement.hidden = true
        view.endEditing(true)
    }

    @IBAction func onCancelPressed(sender: AnyObject) {
        captionView.hidden = true
        captionTextView.text = ""
        captionButton.hidden = true
        photoView.image = nil
        navButton.hidden = true
        cancelButton.hidden = true
        buttonReplacement.hidden = true
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
