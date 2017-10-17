//
//  SwitchTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SwitchTableViewCell: UITableViewCell {
  let uiSwitch = UISwitch()
  let titleLabel = UILabel()

  var isOn: Bool {
    get {
      return uiSwitch.isOn
    }
    set {
      uiSwitch.isOn = newValue
    }
  }

  var handler: ((Bool) -> Void)? = nil

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  init(_ title: String) {
    super.init(style: .default, reuseIdentifier: nil)
    titleLabel.text = title
    setup()
  }

  func setup() {
    selectionStyle = .none
    addSubview(titleLabel)
    addSubview(uiSwitch)

    titleLabel.textAlignment = .left
    titleLabel.font = UIFont.systemFont(ofSize: 15)
    titleLabel.adjustsFontSizeToFitWidth = true
    
    titleLabel <- [
      Left(20),
      Right(5).to(uiSwitch),
      CenterY()
    ]

    uiSwitch.onTintColor = UIColor.red
    uiSwitch.tintColor = UIColor.warmGrey
    
    uiSwitch <- [
      Right(20),
      CenterY()
    ]

    uiSwitch.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    uiSwitch.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)

    uiSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
  }

  func switchAction() {
    handler?(uiSwitch.isOn)
  }
}
