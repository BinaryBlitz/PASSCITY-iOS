//
//  CardUserView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardUserView: UIView {
  let attributesView = UIStackView()
  let menuButton = UIButton(type: .system)
  let footerButton = UIButton()
  let footerButtonView = UIView()

  var isActive: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.2) { [weak self] in
        self?.easy_reload()
        self?.layoutIfNeeded()
      }
      for (index, view) in attributesView.arrangedSubviews.enumerated() {
        if index > 2 && !isActive {
          view.isHidden = true
        } else {
          view.isHidden = false
        }
      }
      isActiveHandler?()
    }
  }

  var menuHandler: (() -> Void)? = nil
  var isActiveHandler: (() -> Void)? = nil

  init() {
    super.init(frame: CGRect.null)
    
    addSubview(menuButton)
    addSubview(attributesView)
    addSubview(footerButton)
    addSubview(footerButtonView)

    footerButtonView.backgroundColor = UIColor.disabledBtnColor
    footerButtonView.cornerRadius = 2
    footerButtonView.isUserInteractionEnabled = false

    attributesView.axis = .vertical
    attributesView.distribution = .fillEqually
    attributesView.alignment = .fill
    attributesView.spacing = 15

    menuButton.contentHorizontalAlignment = .right

    menuButton.setImage(#imageLiteral(resourceName: "iconMenuBig"), for: .normal)
    menuButton.tintColor = .black

    menuButton <- [
      Top(20),
      Right(15)
    ]

    attributesView <- [
      Top(20),
      Left(20),
      Right(>=20).to(menuButton, .left),
      Bottom(5).to(footerButton, .top).with(.low),
    ]

    footerButton.backgroundColor = UIColor.white

    footerButton <- [
      Left(),
      Right(),
      Height(20),
      Bottom()
    ]

    footerButtonView <- [
      Bottom(8),
      Height(4),
      Width(36),
      CenterX()
    ]

    footerButton.addTarget(self, action: #selector(footerButtonAction), for: .touchUpInside)

    self <- [
      Height(138).when { !self.isActive }
    ]

  }

  func footerButtonAction() {
    guard attributesView.arrangedSubviews.count > 3 else { return }
    isActive = !isActive
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(card: PassCityCard) {
    attributesView.arrangedSubviews.forEach { [weak self] view in
      self?.attributesView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }

    for (index, attribute) in card.userAttributes.enumerated() {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
      label.text = attribute.value
      if index > 2 && !isActive {
        label.isHidden = true
      } else {
        label.isHidden = false
      }
      attributesView.addArrangedSubview(label)
    }
  }
}
