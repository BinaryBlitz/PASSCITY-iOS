//
//  SettingsCategoryTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SettingsCategoryTableViewCell: UITableViewCell {
  let iconView = UIImageView()
  let circleView = UIView()
  let titleLabel = UILabel()
  let badgeView = UIView()
  let badgeLabel = UILabel()
  let arrowView = UIImageView(image: #imageLiteral(resourceName: "iconArrowRight"))


  func configure(category: Category, selectedCategories: [Int]? = nil) {
    iconView.kf.setImage(with: category.icon)
    circleView.backgroundColor = category.color
    titleLabel.text = category.title
    badgeLabel.text = "\(selectedCategories?.count ?? category.selected)"
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    backgroundColor = .white

    addSubview(circleView)

    circleView.cornerRadius = 15
    circleView <- [
      Size(30),
      CenterY(),
      Left(20)
    ]

    circleView.addSubview(iconView)
    iconView.tintColor = UIColor.white
    iconView.contentMode = .scaleAspectFit

    iconView <- [
      Center(),
      Edges(>=3)
    ]

    titleLabel.font = UIFont.systemFont(ofSize: 15)
    titleLabel.textAlignment = .left

    addSubview(titleLabel)
    titleLabel <- [
      CenterY(),
      Left(20).to(circleView)
    ]

    addSubview(arrowView)
    arrowView <- [
      CenterY(),
      Right(20)
    ]

    addSubview(badgeView)

    badgeView.backgroundColor = UIColor.warmGrey
    badgeView.cornerRadius = 11

    badgeView <- [
      Height(22),
      Width(>=22),
      Right(16).to(arrowView),
      CenterY()
    ]

    badgeLabel.textColor = UIColor.white
    badgeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
    
    badgeView.addSubview(badgeLabel)

    badgeLabel.textAlignment = .center
    badgeLabel <- [
      Center(),
      Left(>=0),
      Right(>=0)
    ]
  }

}
