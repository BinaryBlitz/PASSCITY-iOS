//
//  SettingsTableSectionView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SettingsTableSectionView: UITableViewHeaderFooterView {
  let iconView = UIImageView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()

  func configure(title: String?, description: String?, icon: UIImage?) {
    titleLabel.text = title
    descriptionLabel.text = description
    iconView.image = icon

    titleLabel.isHidden = title == nil
    iconView.isHidden = title == nil || icon == nil
    descriptionLabel.isHidden = description == nil
    easy_reload()
  }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    let view = UIView()
    backgroundView = view
    view.backgroundColor = .white
    
    view.addSubview(iconView)
    view.addSubview(titleLabel)
    view.addSubview(descriptionLabel)

    iconView.tintColor = UIColor.white
    iconView.contentMode = .scaleAspectFit
    
    iconView <- [
      Left(20),
      Size(12),
      CenterY().to(titleLabel)
    ]

    titleLabel.font = UIFont.systemFont(ofSize: 12)
    titleLabel.textAlignment = .left

    titleLabel <- [
      Top(10),
      Left(6).to(iconView),
      Right(>=0)
    ]

    descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
    descriptionLabel.textColor = UIColor.warmGrey
    descriptionLabel.numberOfLines = 0

    descriptionLabel <- [
      Top(10).to(titleLabel).when { !self.titleLabel.isHidden },
      Left(20),
      Right(<=10),
      CenterY().when { self.titleLabel.isHidden }
    ]
  }
}
