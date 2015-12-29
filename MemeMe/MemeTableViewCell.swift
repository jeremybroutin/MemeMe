
//
//  MemeTableViewCell.swift
//  MemeMyFace
//
//  Created by Jeremy Broutin on 5/14/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewCell: UITableViewCell{
  
  @IBOutlet weak var topTextForCell: UILabel!
  @IBOutlet weak var bottomTextForCell: UILabel!
  @IBOutlet weak var imageForCell: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  //make the text fields non editable
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return false
  }
  
}
