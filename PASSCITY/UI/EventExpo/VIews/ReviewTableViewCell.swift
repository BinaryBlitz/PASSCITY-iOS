//
//  ReviewTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import FloatRatingView

class ReviewTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarView: AvatarView!
  @IBOutlet weak var imagesScrollView: UIScrollView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var comfortRatingView: FloatRatingView!
  @IBOutlet weak var interestingRatingView: FloatRatingView!
  @IBOutlet weak var imageScrollConstraint: NSLayoutConstraint!

  func configure(review: Review) {
    avatarView.configure(imageUrl: nil, user: review.user)
    nameLabel.text = review.user
    descriptionLabel.text = review.text
    dateLabel.text = review.date.shortDate + " " + review.date.time
    comfortRatingView.rating = Float(review.convenient)
    comfortRatingView.rating = Float(review.convenient)
    if review.imgs.isEmpty {
      imagesScrollView.isHidden = true
      imageScrollConstraint.constant = 0
    } else {
      imageScrollConstraint.constant = 67
      imagesScrollView.isHidden = false
    }

  }
}
