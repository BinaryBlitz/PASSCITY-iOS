//
//  AvailableProductsTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Kingfisher
import FloatRatingView

class AvailableProductsTableViewCell: UITableViewCell {
  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tariffLabel: UILabel!
  @IBOutlet weak var validLabel: UILabel!
  @IBOutlet var subTitleLabel: UILabel!
  
  @IBAction func moreButtonAction(_ sender: Any?) {
    moreButtonHandler?()
  }

  var moreButtonHandler: (() -> Void)? = nil

  func configure(product: PassCityProduct) {
    titleLabel.text = product.title
    subTitleLabel.text = product.subTitle
    tariffLabel.text = product.tariff
    validLabel.text = String(product.valid.replacingOccurrences(of: "\t", with: " ", options: [], range: nil))
    circleView.backgroundColor = product.categoryObject?.color ?? UIColor.red
    iconView.kf.setImage(with: product.imgURL)

    switch product.type {
    case .package:
      guard subviews.contains(subTitleLabel) else { break }
      subTitleLabel.removeFromSuperview()

      titleLabel <- [
        Top().to(circleView, .top)
      ]

    case .ticket:
      guard !contentView.subviews.contains(subTitleLabel) else { break }
      contentView.addSubview(subTitleLabel)
      subTitleLabel <- [
        Top().to(circleView, .top),
        Left(20).to(circleView, .right),
        Right().to(moreButton, .left),
      ]

      titleLabel <- [
        Top().to(subTitleLabel, .bottom)
      ]
    }

    easy_reload()
    layoutIfNeeded()
    updateConstraints()
  }

}
