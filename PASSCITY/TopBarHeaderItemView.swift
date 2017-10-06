//
//  TopBarHeaderItemView.swift
//  PASSCITY
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class TopBarHeaderItemView: UIView {
  private let lineView = UIView()
  private let titleButton = UIButton(type: .system)

  var handler: (() -> Void)? = nil

  var isSelected: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.2) { [weak self] in
        guard let `self` = self else { return }
        self.lineView.alpha = self.isSelected ? 1 : 0
      }
    }
  }

  init(title: String, color: UIColor = .red) {
    super.init(frame: CGRect.null)

    titleButton.setTitle(title.uppercased(), for: .normal)
    titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    titleButton.tintColor = UIColor.black
    lineView.backgroundColor = color
    lineView.alpha = 0

    addSubview(titleButton)
    addSubview(lineView)

    titleButton <- [
      Edges()
    ]

    lineView <- [
      Height(1),
      Left(),
      Right(),
      Bottom()
    ]

    titleButton.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
  }

  func buttonTapAction() {
    handler?()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
