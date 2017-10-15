//
//  ProductCardBonusInfoView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProductCardBonusInfoItemView: UIView {
  let titleLabel = UILabel()
  let valueLabel = UILabel()

  var valueText: String? {
    get {
      return valueLabel.text
    }
    set {
      valueLabel.text = newValue
    }
  }

  init(title: String) {
    super.init(frame: CGRect.null)

    addSubview(titleLabel)
    addSubview(valueLabel)

    titleLabel.textColor = UIColor.disabledBtnColor
    titleLabel.font = UIFont.systemFont(ofSize: 8, weight: UIFontWeightSemibold)
    valueLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)

    titleLabel.text = title

    titleLabel <- [
      Top(),
      Left().to(valueLabel, .left)
    ]

    valueLabel <- [
      CenterX(),
      Top(5).to(titleLabel),
      Bottom()
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

