//
//  SettingsSelectableCell.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SettingsSelectableCell: UITableViewCell {
  let iconDoneView = UIImageView(image: #imageLiteral(resourceName: "iconDone").withRenderingMode(.alwaysTemplate))
  let label = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
 var isActive: Bool = false {
    didSet {
      iconDoneView.isHidden = !isActive
      label.textColor = isActive ? .black : .disabledBtnColor
    }
  }

  func setup() {
    addSubview(label)
    addSubview(iconDoneView)

    iconDoneView.tintColor = .red
    iconDoneView.isHidden = true

    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = UIColor.disabledBtnColor

    label <- [
      Left(20),
      CenterY()
    ]

    iconDoneView <- [
      Right(20),
      CenterY()
    ]
  }
}
