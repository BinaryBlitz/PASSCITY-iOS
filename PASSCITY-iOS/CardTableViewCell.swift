//
//  CardTableViewCell.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardTableViewCell: UITableViewCell {
  let cardView = UIView()
  let backgroundImageView = UIImageView()
  let disclosureIndicatorView = UIImageView(image: #imageLiteral(resourceName: "iconArrowDisclosure").withRenderingMode(.alwaysTemplate))
  let titleLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  override var cornerRadius: CGFloat {
    get {
      return cardView.cornerRadius
    }
    set {
      cardView.cornerRadius = newValue
      backgroundImageView.cornerRadius = newValue
    }
  }

  func setup() {
    cardView.clipsToBounds = true
    cardView.cornerRadius = 8
    cardView.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    backgroundImageView.clipsToBounds = true
    backgroundImageView.cornerRadius = 8

    disclosureIndicatorView.tintColor = UIColor.white
  }

  func addConstraints() {
    contentView.addSubview(cardView)

    cardView <- [
      Left(20),
      Right(20),
      Height(>=100),
      Top(5),
      Bottom(5)
    ]

    cardView.addSubview(backgroundImageView)

    backgroundImageView <- [
      Edges()
    ]

    cardView.addSubview(titleLabel)

    titleLabel <- [
      Left().to(cardView.le)
    ]

  }
}
