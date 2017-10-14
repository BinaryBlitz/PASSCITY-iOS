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

  @IBOutlet weak var descriptionButton: GoButton!

  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var datesView: UIView!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
  var icons: [UIImageView] {
    return [commentsImageView, locationImageView, clockImageView]
  }

  var isExpanded: Bool = false {
    didSet {
      bottomConstraint?.isActive = isExpanded
      updateConstraints()
      layoutIfNeeded()
    }
  }

  var likeButtonHandler: (() -> Void)? = nil
  var moreButtonHandler: (() -> Void)? = nil
  var isExpandedHandler: ((Bool) -> Void)? = nil

  @IBAction func likeButtonAction(_ sender: Any) {
  }

  @IBAction func moreButtonAction(_ sender: Any) {
    moreButtonHandler?()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    icons.forEach { $0.image = $0.image?.withRenderingMode(.alwaysTemplate) }
    bottomConstraint?.isActive = false
  }

  func configure(item: PassCityFeedItemShort) {
    titleLabel.text = item.title
    ratingView.rating = item.reviews.rating
    backgroundImageView.kf.setImage(with: item.imgURL)
    commentsCountLabel.text = "\(item.reviews.qty)"
    distationLabel.text = item.distance
    dateLabel.text = item.schedule.isEmpty ? item.dates : item.schedule
    likeButton.isSelected = item.favorites != 0
    descriptionLabel.text = item.description
    datesView.isHidden = item.type != .event
    datesLabel.text = item.dates
  }
  
  @IBAction func bottomButtonTouchDownAction(_ sender: Any) {
    descriptionButton.isHighlighted = true
  }

  @IBAction func bottomButtonTouchUpInsideAction(_ sender: Any) {
    descriptionButton.isHighlighted = false
    isExpandedHandler?(true)
  }
  
  @IBAction func touchUpOutsideAction(_ sender: Any) {
    descriptionButton.isHighlighted = false
  }

  @IBAction func closeButtonAction(_ sender: Any) {
    isExpandedHandler?(false)
  }

}
