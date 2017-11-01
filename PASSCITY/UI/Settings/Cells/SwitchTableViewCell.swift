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
  let descriptionLabel = UILabel()
  let titleView = UIView()
  let iconView = UIImageView()

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

  init(_ title: String, description: String? = nil, image: UIImage? = nil) {
    super.init(style: .default, reuseIdentifier: nil)
    titleLabel.text = title
    descriptionLabel.text = description
    iconView.image = image
    setup()
  }

  func setup() {
    selectionStyle = .none
    addSubview(titleView)
    titleView.addSubview(titleLabel)
    titleLabel.textAlignment = .left
    titleLabel.font = UIFont.systemFont(ofSize: 15)
    titleLabel.adjustsFontSizeToFitWidth = true

    titleLabel <- [
      Top(),
      Left(),
      Right()
    ]

    if let text = descriptionLabel.text, !text.isEmpty {
      descriptionLabel.textColor = .warmGrey
      descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
      titleView.addSubview(descriptionLabel)
      descriptionLabel <- [
        Top().to(titleLabel),
        Left(),
        Right(),
        Bottom()
      ]
    } else {
      titleLabel <- Bottom()
    }
    
    addSubview(uiSwitch)

    if iconView.image != nil {
      addSubview(iconView)
      iconView.contentMode = .scaleAspectFit
      iconView <- [
        Left(20).with(.high),
        Size(20),
        CenterY()
      ]
      titleView <- [
        Left(15).to(iconView),
        Right(5).to(uiSwitch),
        CenterY()
      ]
    } else {
      titleView <- [
        Left(20),
        Right(5).to(uiSwitch),
        CenterY()
      ]
    }


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
