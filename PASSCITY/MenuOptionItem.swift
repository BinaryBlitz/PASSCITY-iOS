//
//  MenuOptionItem.swift
//  PASSCITY
//
//  Created by Алексей on 10.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import EasyPeasy
import UIKit

class MenuOptionItemView: UIView {
  let label = UILabel()
  let iconView = UIImageView()
  let button = UIButton()

  var handler: (() -> Void)? = nil

  init(icon: UIImage? = nil, title: String) {
    super.init(frame: CGRect.null)

    backgroundColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)

    addSubview(iconView)

    iconView <- [
      CenterY(),
      Left(30),
      Size(14)
    ]

    iconView.contentMode = .scaleAspectFit

    addSubview(label)

    label <- [
      CenterY(),
      Left(30).to(iconView)
    ]

    iconView.image = icon
    label.text = title

    addSubview(button)

    button.setTitle("", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    button <- [
      Edges()
    ]
  }

  func buttonAction() {
    handler?()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
