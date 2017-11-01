//
//  GoButton.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GoButton: UIButton {
  let animationDuration = 0.2

  var disabledAlpha: CGFloat = 0.5

  @IBInspectable var defaultBackgroundColor: UIColor = UIColor.red

  override var isEnabled: Bool {
    didSet {
      let isEnabled = self.isEnabled
      UIView.animate(withDuration: animationDuration, animations: { [weak self] in
        self?.backgroundColor = !isEnabled ? UIColor.disabledBtnColor : self?.defaultBackgroundColor
        self?.alpha = !isEnabled ? (self?.disabledAlpha ?? 0.5) : 1
        self?.layoutIfNeeded()
      })
    }
  }

  override var isHighlighted: Bool {
    didSet {
      let isHighlighted = self.isHighlighted
      guard isEnabled else { return }
      UIView.animate(withDuration: animationDuration, animations: { [weak self] in
        self?.backgroundColor = isHighlighted ? self?.defaultBackgroundColor.darker() : self?.defaultBackgroundColor
        self?.layoutIfNeeded()
      })
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.frame.height / 2
  }

  init(color: UIColor = .red, title: String = "", image: UIImage? = nil, textColor: UIColor = .white, font: UIFont = UIFont.buttonCommonFont) {
    super.init(frame: .zero)
    setTitle(title.uppercased(), for: .normal)
    setTitleColor(textColor, for: .normal)
    setImage(image, for: .normal)
    self.titleLabel?.font = font
    defaultBackgroundColor = color
    backgroundColor = defaultBackgroundColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
