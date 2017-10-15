//
//  ProductCardBonusView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardBonusView: UIView {
  let bonusStackView = UIStackView()

  let bonusAccruedView = ProductCardBonusInfoItemView(title: "НАЧИСЛЕНО")
  let bonusChargedView = ProductCardBonusInfoItemView(title: "ИСПОЛЬЗОВАНО")
  let bonusBalanceView = ProductCardBonusInfoItemView(title: "ОСТАТОК")
  let descriptionLabel = UILabel()

  var bonusViews: [ProductCardBonusInfoItemView] {
    return [bonusAccruedView, bonusChargedView, bonusBalanceView]
  }

  init() {
    super.init(frame: CGRect.null)

    addSubview(bonusStackView)
    addSubview(descriptionLabel)

    bonusStackView.axis = .horizontal
    bonusStackView.distribution = .fillEqually

    bonusStackView <- [
      Top(30),
      Left(),
      Right()
    ]

    descriptionLabel.numberOfLines = 3
    descriptionLabel.textAlignment = .center

    descriptionLabel <- [
      Top(16).to(bonusStackView),
      Left(20),
      Right(20),
      Bottom(17)
    ]

    descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
    descriptionLabel.textColor = UIColor.warmGrey
    descriptionLabel.text = "Бонусы начисляются за каждое использование Вашего промо-кода. Поделитесь промо-кодом с друзьями и они получат скидку."

    for view in bonusViews {
      bonusStackView.addArrangedSubview(view)
    }

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(card: PassCityCard) {
    bonusAccruedView.valueText = card.bonusAccrued.replacingOccurrences(of: "&#x584;", with: "₽")
    bonusChargedView.valueText = card.bonusCharged.replacingOccurrences(of: "&#x584;", with: "₽")
    bonusBalanceView.valueText = card.bonusBalance.isEmpty ? "0 ₽" : card.bonusBalance.replacingOccurrences(of: "&#x584;", with: "₽")
    layoutIfNeeded()
  }
}
