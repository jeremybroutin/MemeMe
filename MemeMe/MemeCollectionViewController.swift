//
//  MemeCollectionViewController.swift
//  MemeMyFace
//
//  Created by Jeremy Broutin on 5/15/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var memes: [Meme]!
  
  /************************************* MARK: - App Life Cycle ***************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set navigation bar title with an image
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.contentMode = .ScaleAspectFit
    let image = UIImage(named: "navIcon")
    imageView.image = image
    navigationItem.titleView = imageView
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // make sure the edit view will be refreshed
    Variables.shouldRefresh = true
    
    //access the memes array content
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
    self.collectionView?.reloadData()
  }
  
  /*************************************** MARK: - IBActions ******************************************/
  
  @IBAction func addNewMeme(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func editCollection(sender: AnyObject) {
    if(self.navigationItem.leftBarButtonItem?.title == "Edit"){
      self.navigationItem.leftBarButtonItem?.title = "Done"
      for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
        let indexpath : NSIndexPath = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)!
        let cell = self.collectionView!.cellForItemAtIndexPath(indexpath) as! MemeCollectionViewCell
        //Close Button
        let close : UIButton = cell.deleteButton as UIButton
        close.hidden = false
      }
    } else {
      self.navigationItem.leftBarButtonItem?.title = "Edit"
      self.collectionView?.reloadData()
    }
  }
  
  /******************************* MARK: - UICollectionViewDataSource **********************************/
  
  //number of items
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.memes.count == 0 {
      
      //display empty list message
      var emptyList : UILabel
      emptyList = UILabel(frame: CGRectMake(0, 0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height))
      emptyList.contentMode = UIViewContentMode.ScaleAspectFit
      emptyList.textAlignment = NSTextAlignment.Center
      emptyList.font = UIFont (name: "AppleSDGothicNeo-Thin", size: 20)
      emptyList.numberOfLines = 2
      emptyList.lineBreakMode = NSLineBreakMode.ByWordWrapping
      emptyList.preferredMaxLayoutWidth = 200
      emptyList.textColor = UIColor.lightGrayColor()
      emptyList.text = "Your collection is empty! \nStart a meme by clicking '+'"

      //set back to label view
      self.collectionView!.backgroundView = emptyList;
      
      //disable edit button
      self.navigationItem.leftBarButtonItem?.enabled = false
    }
    return self.memes.count
  }
  
  //set the cell content
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
    let meme = self.memes[indexPath.item]
    cell.memedImage.image = meme.memedImage
    
    //enable the delete button if edit mode
    if self.navigationItem.leftBarButtonItem!.title == "Edit" {
      cell.deleteButton?.hidden = true
    } else {
      cell.deleteButton?.hidden = false
    }
    cell.deleteButton?.layer.setValue(indexPath.row, forKey: "index")
    //add an event listener to delete the meme when delete button is pressed
    cell.deleteButton?.addTarget(self, action: "deletePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
    
    return cell

  }
  
  //function handling the meme deletion
  func deletePhoto(sender:UIButton) {
    let i : Int = (sender.layer.valueForKey("index")) as! Int
    memes.removeAtIndex(i)
    
    //access the memes array content
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    //delete meme in memes array
    appDelegate.memes.removeAtIndex(i)
    
    self.collectionView!.reloadData()
  }

  //set the max space between cells
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 5
  }
  
  /***************************** MARK: - UICollectionView Delegate Methods *****************************/
  
  //open meme on cell selection
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
    detailController.meme = self.memes[indexPath.row]
    detailController.memeIndex = indexPath.row
    detailController.hidesBottomBarWhenPushed = true
    self.navigationController!.pushViewController(detailController, animated: true)
  }
}
  

