//
//  OverallRatingCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import FloatRatingView

class OverallRatingCell: UITableViewCell {

  @IBOutlet weak var comfortableAverageLabel: UILabel!
  @IBOutlet weak var interestingAverageLabel: UILabel!
  @IBOutlet weak var leftReviewButton: UIButton!
  @IBOutlet weak var interestingRatingView: FloatRatingView!
  @IBOutlet weak var comfortableRatingView: FloatRatingView!
  
  var reviewHandler: (() -> Void)? = nil

  @IBAction func reviewButtonAction(_ sender: Any) {
    reviewHandler?()
  }

  func configure(reviewsState: ReviewsState) {
    comfortableAverageLabel.text = "\(reviewsState.qty)"
    interestingAverageLabel.text = "\(reviewsState.qty)"
    interestingRatingView.rating = reviewsState.rating
    comfortableRatingView.rating = reviewsState.rating

  }
  
}
