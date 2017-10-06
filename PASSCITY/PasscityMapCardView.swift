//
//  CardView.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import EasyPeasy

class PasscityMapCardView: UIView {

  init() {
    super.init(frame: CGRect.null)
    shadow = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
