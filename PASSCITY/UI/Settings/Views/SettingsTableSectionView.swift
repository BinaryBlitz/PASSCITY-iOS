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
  let stackView = UIStackView()
  let titleView = UIView()

  func configure(title: String?, description: String?, icon: UIImage?) {
    titleLabel.text = title
    descriptionLabel.text = description
    iconView.image = icon

    if title == nil {
      stackView.removeArrangedSubview(titleView)
      titleView.removeFromSuperview()
    } else if !stackView.arrangedSubviews.contains(titleView) {
      stackView.removeArrangedSubview(descriptionLabel)
      descriptionLabel.removeFromSuperview()

      stackView.addArrangedSubview(titleView)
      stackView.addArrangedSubview(descriptionLabel)
    }

    if description == nil {
      stackView.removeArrangedSubview(descriptionLabel)
      descriptionLabel.removeFromSuperview()
    } else if !stackView.arrangedSubviews.contains(descriptionLabel) {
      stackView.addArrangedSubview(descriptionLabel)
    }

    updateConstraints()
    layoutIfNeeded()
  }

  var descriptionLabelHidden: Bool = false {
    didSet {
      descriptionLabel.isHidden = descriptionLabelHidden
    }
  }

  var titleLabelHidden: Bool = false {
    didSet {
      titleLabel.isHidden = titleLabelHidden

    }
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
    
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleView)
    stackView.addArrangedSubview(descriptionLabel)
    titleView.addSubview(titleLabel)
    titleView.addSubview(iconView)

    iconView.tintColor = UIColor.white
    iconView.contentMode = .scaleAspectFit

    titleLabel.font = UIFont.systemFont(ofSize: 12)
    titleLabel.textAlignment = .left

    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.spacing = 10

    stackView <- [
      Left(20),
      Right(15),
      CenterY()
    ]

    iconView <- [
      Left(),
      Size(12),
      CenterY().to(titleLabel)
    ]

    titleLabel <- [
      Top(),
      Left(6).to(iconView),
      Right(>=0),
      Bottom()
    ]

    descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
    descriptionLabel.textColor = UIColor.warmGrey
    descriptionLabel.numberOfLines = 0
  }
}
