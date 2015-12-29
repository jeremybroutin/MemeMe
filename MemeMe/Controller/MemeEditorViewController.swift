//
//  MemeEditorViewController.swift
//  MemeMyFace
//
//  Created by Jeremy Broutin on 5/13/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

/*
struct Meme {
  let topText: String
  let bottomText: String
  let image: UIImage
  let memedImage: UIImage
  
  init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage){
    self.topText = topText
    self.bottomText = bottomText
    self.image = image
    self.memedImage = memedImage
  }
}*/

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  /**************************************** MARK: - Properties ****************************************/
  
  @IBOutlet weak var shareButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var newMemeButton: UIBarButtonItem!
  
  @IBOutlet weak var originalImage: UIImageView!
  @IBOutlet weak var topText: UITextField!
  @IBOutlet weak var bottomText: UITextField!
  
  var skipToTabBarController = false
  var canEditTextFields = false
  var defaultTopText: String?
  var defaultBottomText:String?
  var memedImage:UIImage!
  var memes: [Meme]!
  
  //set attributes for text fields
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName :  UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -3.0
  ]
  
  /************************************** MARK: - App Life Cycle **************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //access the memes array content
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
    
    //check if there are already some memes to redirect the users
    if self.memes.count > 0 {
      skipToTabBarController = true
    }
    
    //initialize the view elements
    initializeView()
    
    //enable or disable camera button if device has one
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    //disable the share button by default
    self.shareButton.enabled = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //set custom navigation bar with image
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.contentMode = .ScaleAspectFit
    let image = UIImage(named: "navIcon")
    imageView.image = image
    navigationItem.titleView = imageView
    
    //subscribe to keyboard notifications
    self.subscribeToKeyboardNotifications()
    
    //reset all elements to default
    if Variables.shouldRefresh{
      Variables.shouldRefresh = false
      initializeView()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    
    // skip meme editor if existing memes
    if skipToTabBarController {
      skipToTabBarController = false
      self.showMemesTabBar()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // unsubscribe from keyboard notifications
    self.unsubscribeFromKeyboardNotifications()
  }
  

  

  /**************************************** MARK: - IBActions ****************************************/
  
  //pick an image from gallery (search button)
  @IBAction func pickImageFromGallery(sender: UIBarButtonItem) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(pickerController, animated: true, completion: nil)
  }
  
  // take a picture (camera button)
  @IBAction func takePictureFromCamera(sender: UIBarButtonItem) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = UIImagePickerControllerSourceType.Camera
    // forcing camera mode only (no video)
    pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
    self.presentViewController(pickerController, animated: true, completion: nil)
  }
  
  // cancel meme edition and go to table view
  @IBAction func cancelMemeEdit(sender: UIBarButtonItem) {
    showMemesTabBar()
  }
  
  /****************************** Mark: - UIImagePicker Delegate methods ******************************/
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      // set the original image with the selected image
      originalImage.image = selectedImage
      // enable share button
      shareButton.enabled = true
    }
    dismissViewControllerAnimated(true, completion: nil)
    // enable the edition of the text fields
    canEditTextFields = true
  }
  
  // present the cancel option for the imagePickerController
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /****************************** MARK: - UITextFieldsDataSource **************************************/
  
  // only enabled text field edition if image has been selected
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return canEditTextFields
  }
  
  // clear text field on edition only if default text
  func textFieldDidBeginEditing(textField: UITextField) {
    if ((textField.text == self.defaultTopText) || (textField.text == self.defaultBottomText)){
      textField.text = nil
    }
  }
  
  // allow return interaction for text fields
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }

  /********************************** MARK: - Keyboard notifications **********************************/
  
  // functions to get notification about keyboard appeareance/disappearence
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name:
      UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name:
      UIKeyboardWillHideNotification, object: nil)
  }
  
  // move frame up the keyboard when it appeared
  func keyboardWillShow(notification: NSNotification) {
    if bottomText.isFirstResponder(){
      self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  // replace the frame after the keyboard is hidden
  func keyboardWillHide(notification: NSNotification) {
    if bottomText.isFirstResponder(){
      self.view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  // get the keyboard height
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.CGRectValue().height
  }
  
  /*********************************** MARK: - Helper functions ***************************************/
  
   // set all default elements
  func initializeView(){
    //set the image to nil by default
    originalImage.image = nil
    
    // make sure Share button is disabled
    shareButton.enabled = false
    
    // set the top text attributes
    topText.defaultTextAttributes = memeTextAttributes
    topText.borderStyle = .None
    topText.text = "ADD TOP TEXT"
    topText.textAlignment = NSTextAlignment.Center
    topText.delegate = self
    
    // set the bottom text attributes
    bottomText.defaultTextAttributes = memeTextAttributes
    bottomText.borderStyle = .None
    bottomText.text = "ADD BOTTOM TEXT"
    bottomText.textAlignment = NSTextAlignment.Center
    bottomText.delegate = self
    
    // set default texts
    defaultTopText = topText.text
    defaultBottomText = bottomText.text
  }
  
  // show tab bar view controller
  func showMemesTabBar() {
    var controller: UITabBarController
    controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
    self.presentViewController(controller, animated: true, completion: nil)
  }
   
  // generate a memedImage
  func generateMemedImage() -> UIImage
  {
    // hide toolbar and navbar before capturing image
    self.navigationController?.navigationBar.hidden = true
    self.navigationController?.setToolbarHidden(true, animated: true)
    
    // render view to an image and capture entire screen
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame,
      afterScreenUpdates: true)
    let memedImage : UIImage =
    UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // show toolbar and navbar now that the meme has been captured
    self.navigationController?.navigationBar.hidden = false
    self.navigationController?.setToolbarHidden(false, animated: true)
    
    return memedImage
  }
  
  //save meme into our array of memes
  func saveMeme() {
    //create the meme
    let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, image: self.originalImage.image!, memedImage:self.generateMemedImage())
    //add it to the memes array in the Application Delegate
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
  }
  
  //display the activity controller to share/save the meme
  @IBAction func showActivityController(sender: UIBarButtonItem) {
    self.memedImage = generateMemedImage()
    let activityController = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
    activityController.completionWithItemsHandler = saveMemeAfterSharing
    self.presentViewController(activityController, animated: true, completion: nil)
  }
  
  // activity controller completion handler
  func saveMemeAfterSharing(activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) {
    if completed {
      self.saveMeme()
      self.dismissViewControllerAnimated(true, completion: nil)
      showMemesTabBar()
    }
  }

}
