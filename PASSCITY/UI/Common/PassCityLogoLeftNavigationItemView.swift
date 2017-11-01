//
//  PassCityLogoLeftNavigationItemView.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PassCityLogoLeftNavigationItemView: UIView {

  init() {
    super.init(frame: CGRect.null)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  func setupView() {
    let passcityImageView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))
    addSubview(passcityImageView)
    passcityImageView <- [
      CenterY(),
      Left(20),
      Right()
    ]
  }
}
