//
//  GoButton.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GoButton: UIButton {
  let animationDuration = 0.2

  @IBInspectable var defaultBackgroundColor: UIColor = UIColor.red

  override var isEnabled: Bool {
    didSet {
      if !isEnabled {
        alpha = 0.6
      } else {
        alpha = 1
      }
    }
  }

  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.backgroundColor = self.defaultBackgroundColor.darker()
      } else {
        UIView.animate(withDuration: animationDuration, animations: {
          self.backgroundColor = self.defaultBackgroundColor
        })
      }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.frame.width / 2
  }

  init(color: UIColor = .red, title: String, textColor: UIColor = .white, font: UIFont = UIFont.buttonCommonFont) {
    super.init(type: .custom)
    setTitle(title.uppercased(), for: .normal)
    setTitleColor(textColor, for: .normal)
    self.titleLabel?.font = font
    defaultBackgroundColor = color
    backgroundColor = defaultBackgroundColor
  }
  
}
