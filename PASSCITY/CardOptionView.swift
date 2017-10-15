//
//  CardOptionView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardOptionView: UIView {
  let iconButton = UIButton(type: .system)
  let titleButton = UIButton(type: .system)
  let button = UIButton()

  var handler: (() -> Void)? = nil

  var isSelected: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.2) {
        self.iconButton.tintColor = self.isSelected ? .red : .black
        self.titleButton.tintColor = self.isSelected ? .red : .black
        self.titleButton.titleLabel?.textColor = self.isSelected ? .red : .black
      }
    }
  }

  init() {
    super.init(frame: CGRect.null)

    addSubview(iconButton)
    addSubview(titleButton)

    iconButton <- [
      Top(18),
      Height(30),
      CenterX()
    ]

    titleButton <- [
      Top(9).to(iconButton),
      Bottom(13),
      CenterX()
    ]

    titleButton.titleLabel?.textColor = UIColor.black
    titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    titleButton.tintColor = .black
    iconButton.tintColor = .black

    addSubview(button)
    button <- Edges()

    button.addTarget(self, action: #selector(touchDown), for: .touchDown)
    button.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    button.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)

  }

  func touchDown() {
    iconButton.isHighlighted = true
    titleButton.isHighlighted = true
  }

  func touchUpInside() {
    iconButton.isHighlighted = false
    titleButton.isHighlighted = false

    handler?()
  }

  func touchDragOutside() {
    iconButton.isHighlighted = false
    titleButton.isHighlighted = false
  }

  func configure(icon: UIImage, title: String) {
    titleButton.setTitle(title, for: .normal)
    iconButton.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
