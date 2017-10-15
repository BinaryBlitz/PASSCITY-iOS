//
//  CardPromoCodeView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardPromoCodeView: UIView {
  let promoStackView = UIStackView()
  let button = UIButton()
  let promoCodeView = ProductCardBonusInfoItemView(title: "ПРОМОКОД")
  let usedView = ProductCardBonusInfoItemView(title: "ИСПОЛЬЗОВАНО")
  let shareLabel = UILabel()
  let shareIcon = UIImageView(image: #imageLiteral(resourceName: "iconMenuShare"))

  var promoCodeViews: [ProductCardBonusInfoItemView] {
    return [promoCodeView, usedView]
  }

  var handler: (() -> Void)? = nil

  init() {
    super.init(frame: CGRect.null)
    addSubview(promoStackView)
    addSubview(promoCodeView)
    addSubview(shareLabel)
    addSubview(shareIcon)
    addSubview(button)

    promoStackView.axis = .horizontal
    promoStackView.distribution = .fillEqually

    promoStackView <- [
      Top(30),
      Left(),
      Right()
    ]

    shareLabel.numberOfLines = 0

    shareLabel <- [
      Top(25).to(promoStackView),
      Left(20),
      Bottom(24)
    ]

    shareIcon <- [
      CenterY().to(shareLabel),
      Right(20)
    ]

    shareLabel.font = UIFont.systemFont(ofSize: 12)
    shareLabel.text = "Поделитесь промо-кодом с друзьями"

    for view in promoCodeViews {
      promoStackView.addArrangedSubview(view)
    }

    addSubview(button)

    button <- Edges()

    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func buttonAction() {
    handler?()
  }

  func configure(card: PassCityCard) {
    promoCodeView.valueText = card.promoCode
    usedView.valueText = "\(card.promoCodeUsed) раз"
    layoutIfNeeded()
  }
}
