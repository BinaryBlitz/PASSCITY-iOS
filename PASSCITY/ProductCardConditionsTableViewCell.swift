
//
//  ProductCardConditionsTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProductCardConditionsTableViewCell: UITableViewCell {
  let dotLabel = UILabel()
  let tipLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    selectionStyle = .none
    addSubview(dotLabel)
    addSubview(tipLabel)
    dotLabel.text = "•"

    dotLabel <- [
      Left(20),
      CenterY()
    ]

    [tipLabel, dotLabel].forEach { label in
      label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
    }

    tipLabel.numberOfLines = 0
    tipLabel.textAlignment = .left
    tipLabel <- [
      Left(40),
      Top(10),
      Bottom(10),
      Right(20)
    ]
  }

  func configure(_ tip: String) {
    tipLabel.text = tip
    layoutIfNeeded()
    updateConstraintsIfNeeded()
  }
}
