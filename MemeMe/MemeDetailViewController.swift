//
//  MemeDetailViewController.swift
//  MemeMyFace
//
//  Created by Jeremy Broutin on 5/14/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
  
  @IBOutlet weak var memedImage: UIImageView!
  var memes: [Meme]!
  var meme: Meme!
  var memeIndex: Int!
  
  /********************************** MARK: - App Life Cycle ***********************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set the image view with the meme memedImage property
    self.memedImage.image = meme.memedImage
    
    //set the delete button in navigation bar
    let deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteMeme")
    self.navigationItem.rightBarButtonItem = deleteButton

  }
  
  /********************************** MARK: - Helper functions ***********************************/
  
  //function to delete meme
  func deleteMeme() {
    
    //access the memes array content
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    
    appDelegate.memes.removeAtIndex(memeIndex)
    self.navigationController!.popViewControllerAnimated(true)
  }
  
}
