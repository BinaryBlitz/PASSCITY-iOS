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
  
  @IBOutlet weak var interestingCountLabel: UILabel!

  @IBOutlet weak var comfortableCountLabel: UILabel!
  
  var reviewHandler: (() -> Void)? = nil

  @IBAction func reviewButtonAction(_ sender: Any) {
    reviewHandler?()
  }

  func configure(reviewsState: ReviewsState) {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    comfortableAverageLabel.text = "\(formatter.string(from: NSNumber(value: reviewsState.rating))!)"
    interestingAverageLabel.text = "\(formatter.string(from: NSNumber(value: reviewsState.rating))!)"

    interestingCountLabel.text = "\(reviewsState.qty) оценок"
    comfortableCountLabel.text = "\(reviewsState.qty) оценок"
    interestingRatingView.rating = reviewsState.rating
    interestingRatingView.rating = reviewsState.rating
    comfortableRatingView.rating = reviewsState.rating

  }
  
}
