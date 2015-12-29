//
//  MemeTableViewController.swift
//  MemeMyFace
//
//  Created by Jeremy Broutin on 5/14/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
  
  var memes: [Meme]!
  
  @IBOutlet weak var addMemeButton: UIBarButtonItem!
  
  /************************************** MARK: - App Life Cycle **************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = editButtonItem()
    
    //register custom cell
    let nib = UINib(nibName: "viewTableCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
    
    //set custom navigation bar with image
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
    
    // access the memes array content
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
    
    self.tableView.reloadData()
  }
  
  /**************************************** MARK: - IBActions *****************************************/
  
  @IBAction func addNewMeme(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func editTable(sender: AnyObject) {
    self.tableView.setEditing(true, animated: true)
  }
  
  
  /********************************** MARK: - UITableViewDataSource ***********************************/
  
  // set number of rows
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.memes.count == 0 {
      
      // display empty list message
      var emptyList : UILabel
      emptyList = UILabel(frame: CGRectMake(0, 0, self.tableView!.bounds.size.width, self.tableView!.bounds.size.height))
      emptyList.contentMode = UIViewContentMode.ScaleAspectFit
      emptyList.textAlignment = NSTextAlignment.Center
      emptyList.font = UIFont (name: "AppleSDGothicNeo-Thin", size: 20)
      emptyList.numberOfLines = 2
      emptyList.lineBreakMode = NSLineBreakMode.ByWordWrapping
      emptyList.preferredMaxLayoutWidth = 200
      emptyList.textColor = UIColor.lightGrayColor()
      emptyList.text = "Your list is empty! \nStart a meme by clicking '+'"
      
      // set back to label view
      self.tableView!.backgroundView = emptyList;
      
      // no separator
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      
      // disable edit button
      self.navigationItem.leftBarButtonItem?.enabled = false
    }
    return self.memes.count
  }
  
  // set cell format and content
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: MemeTableViewCell = tableView.dequeueReusableCellWithIdentifier("customCell") as! MemeTableViewCell
    let meme = self.memes[indexPath.row]
    
    // set the name and image
    cell.imageForCell.image = meme.memedImage
    cell.topTextForCell.text = meme.topText
    cell.bottomTextForCell.text = meme.bottomText
    
    return cell
  }
  
  // set the height of each row
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 56
  }
  
  /******************************** MARK: - UITableViewDelegate Methods ********************************/
  
  // handle cell click
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController")as! MemeDetailViewController
    detailController.meme = self.memes[indexPath.row]
    detailController.memeIndex = indexPath.row
    detailController.hidesBottomBarWhenPushed = true
    self.navigationController!.pushViewController(detailController, animated: true)
  }
  
  // delete row
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      memes.removeAtIndex(indexPath.row)
      
      //access the memes array content
      let object = UIApplication.sharedApplication().delegate
      let appDelegate = object as! AppDelegate
      //delete meme in memes array
      appDelegate.memes.removeAtIndex(indexPath.row)
      
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  }
}
