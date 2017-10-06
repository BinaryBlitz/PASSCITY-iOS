//
//  PassCityButtonsRightNavigationItem.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PassCityButtonsRightNavigationItemView: UIView {
  private let buttonsStackView = UIStackView()

  init() {
    super.init(frame: CGRect.null)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  func setupView() {
    isUserInteractionEnabled = true
    buttonsStackView.isUserInteractionEnabled = true
    buttonsStackView.axis = .horizontal
    buttonsStackView.distribution = .equalSpacing
    buttonsStackView.spacing = 30
    
    addSubview(buttonsStackView)
    buttonsStackView <- [
      CenterY(),
      Left(20),
      Right()
    ]
  }

  func addButton(_ button: UIButton) {
    button.adjustsImageWhenHighlighted = true
    buttonsStackView.addArrangedSubview(button)
    layoutIfNeeded()
  }
}

