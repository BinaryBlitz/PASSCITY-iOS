//
//  CardBalanceView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardBalanceView: UIView {
  let titleLabel = UILabel()
  let valueLabel = UILabel()

  var handler: (() -> Void)? = nil

  init() {
    super.init(frame: CGRect.null)
    addSubview(titleLabel)
    addSubview(valueLabel)

    titleLabel.text = "Баланс карты"
    valueLabel.text = "Данные недоступны"

    titleLabel.textColor = UIColor.warmGrey
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
    valueLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)

    titleLabel <- [
      Top(42),
      CenterX()
    ]

    valueLabel <- [
      Top(10).to(titleLabel),
      CenterX(),
      Bottom(24)
    ]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func buttonAction() {
    handler?()
  }

  func configure(card: PassCityCard) {
    valueLabel.text = card.balance
    layoutIfNeeded()
  }
}
