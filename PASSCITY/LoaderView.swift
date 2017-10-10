//
//  LoaderView.swift
//  PASSCITY
//
//  Created by Алексей on 10.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class LoaderView: UIView {
  let imageView = UIImageView(image: UIImage.gifImageWithName(name: "preloader_3"))

  func setup() {
    addSubview(imageView)

    imageView <- [
      Center()
    ]
  }

  init() {
    super.init(frame: CGRect.null)
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
}
