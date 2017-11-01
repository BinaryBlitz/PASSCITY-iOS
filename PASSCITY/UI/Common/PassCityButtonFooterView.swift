//
//  PassCityButtonFooterView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PassCityTableButtonFooterView: UIView {
  let button: GoButton
  var buttonHandler: (() -> Void)? = nil

  var isEnabled: Bool {
    get {
      return button.isEnabled
    }
    set {
      button.isEnabled = newValue
    }
  }

  init(title: String, color: UIColor = .red) {
    self.button = GoButton(color: color, title: title)
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 104))
    setup(title)
  }

  func setup(_ title: String) {
    backgroundColor = UIColor.clear

    button.cornerRadius = 22
    addSubview(button)

    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    button <- [
      Height(44),
      Left(20),
      Right(20),
      Top(30),
      Bottom(30)
    ]
  }

  func buttonAction() {
    buttonHandler?()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
