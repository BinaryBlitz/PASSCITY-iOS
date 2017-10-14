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

  @IBAction func moreButtonAction(_ sender: Any?) {
    moreButtonHandler?()
  }

  var moreButtonHandler: (() -> Void)? = nil

  func configure(product: PassCityProduct) {
    titleLabel.text = product.title
    tariffLabel.text = product.tariff
    validLabel.text = String(product.valid.replacingOccurrences(of: "\t", with: " ", options: [], range: nil))

    circleView.backgroundColor = product.categoryObject?.color ?? UIColor.red
    iconView.kf.setImage(with: product.imgURL)

    layoutIfNeeded()
    updateConstraints()
  }

}
