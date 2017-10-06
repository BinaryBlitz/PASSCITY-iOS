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
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var tariffLabel: UILabel!
  @IBOutlet weak var validLabel: UILabel!

  func configure(product: PassCityProductShort) {
    titleLabel.text = product.title
    subtitleLabel.text = product.subTitle
    tariffLabel.text = product.tariff
    validLabel.text = product.valid

    circleView.backgroundColor = product.categoryObject?.color ?? UIColor.red
    iconView.kf.setImage(with: product.imgURL) { [weak self] image, _, _, _ in
      guard let image = image?.withRenderingMode(.alwaysTemplate) else { return }
      self?.iconView.image = image
      self?.iconView.tintColor = UIColor.white
    }
  }

}
