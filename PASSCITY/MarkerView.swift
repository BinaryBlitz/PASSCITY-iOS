//
//  MarkerView.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import EasyPeasy

class PasscityMarkerView: UIView {
  let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "locationPin"))
  let iconImageView = UIImageView()

  init(color: UIColor = .red, iconUrl: URL?) {
    super.init(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
    backgroundImageView.image = backgroundImageView.image?.withRenderingMode(.alwaysTemplate)
    backgroundImageView.tintColor = color
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.kf.setImage(with: iconUrl)
    addSubview(backgroundImageView)
    backgroundImageView <- Edges()

    addSubview(iconImageView)
    iconImageView <- [
      CenterX(),
      Top(5),
      Size(25)
    ]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
