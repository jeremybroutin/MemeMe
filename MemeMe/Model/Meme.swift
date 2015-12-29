//
//  Meme.swift
//  MemeMe
//
//  Created by Jeremy Broutin on 12/29/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

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
}
