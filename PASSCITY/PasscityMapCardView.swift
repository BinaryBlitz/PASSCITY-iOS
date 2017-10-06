//
//  CardView.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import EasyPeasy
import FloatRatingView

class PasscityMapCardView: UIView {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ratingView: FloatRatingView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  var closeButtonHandler: (() -> Void)? = nil

  @IBAction func closeButtonAction(_ sender: Any) {
    closeButtonHandler?()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    shadow = true
  }

  func configure(item: PassCityFeedItemShort) {
    imageView.kf.setImage(with: item.imgURL)
    titleLabel.text = item.title
    ratingView.rating = item.reviews.rating
    commentsCountLabel.text = "\(item.reviews.qty)"
    distanceLabel.text = item.distance
    dateLabel.text = item.dates
  }
}
