//
//  AvailableAnnouncesTableViewCell.swift
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

class AvailableAnnouncesTableViewCell: UITableViewCell {
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var ratingView: FloatRatingView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var distationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  @IBOutlet weak var commentsImageView: UIImageView!
  @IBOutlet weak var locationImageView: UIImageView!
  @IBOutlet weak var clockImageView: UIImageView!

  var icons: [UIImageView] {
    return [commentsImageView, locationImageView, clockImageView]
  }

  var likeButtonHandler: (() -> Void)? = nil
  var moreButtonHandler: (() -> Void)? = nil

  @IBAction func likeButtonAction(_ sender: Any) {
  }

  @IBAction func moreButtonAction(_ sender: Any) {
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    icons.forEach { $0.image = $0.image?.withRenderingMode(.alwaysTemplate) }
  }

  func configure(item: PassCityFeedItemShort) {
    titleLabel.text = item.title
    ratingView.rating = item.reviews.rating
    backgroundImageView.kf.setImage(with: item.imgURL)
    commentsCountLabel.text = "\(item.reviews.qty)"
    distationLabel.text = item.distance
    dateLabel.text = item.dates
    likeButton.isSelected = item.favorites != 0
  }

}
