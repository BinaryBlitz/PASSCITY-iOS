//
//  EventExpoHeaderView.swift
//  PASSCITY
//
//  Created by Алексей on 02.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import FloatRatingView


class EventExpoHeaderView: UIView {
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var rateButton: UIButton!
  @IBOutlet weak var ratingView: FloatRatingView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var distationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var eventBeforeView: UIView!

  @IBOutlet weak var eventBeforeDateLabel: UILabel!
  @IBOutlet weak var commentsImageView: UIImageView!
  @IBOutlet weak var locationImageView: UIImageView!
  @IBOutlet weak var clockImageView: UIImageView!
  @IBOutlet weak var itemsStackView: UIStackView!

  @IBAction func rateButtonAction(_ sender: Any) {
  }

  @IBAction func shareButtonAction(_ sender: Any) {
  }
  @IBOutlet weak var footerButtonView: UIView!

	@IBOutlet weak var toggleButton: UIButton!
	var isActiveHandler: ((Bool) -> Void)? = nil

  var tableView: UITableView? = nil

  var isActive: Bool = false {
    didSet {
		descriptionLabel.numberOfLines  =  0
		layoutIfNeeded()
		isActiveHandler?(isActive)
		toggleButton.setImage ( isActive ? #imageLiteral(resourceName: "iconNavbarClose") : #imageLiteral(resourceName: "handle")
			, for: .normal)
    }
  }
  
  @IBAction func footerButtonTapped(_ sender: Any) {
    isActive = !isActive
  }

  
  @IBOutlet var dateTimePlaceIcons: [UIImageView]!
  
  var headerItemViews: [GoBarHeaderItemView] = []

  var screenType: PassCityFeedItemType! {
    didSet {
      setup()
    }
  }

  override func awakeFromNib() {
    eventBeforeView.isHidden = true
  }

  var currentEventItem: EventHeaderItem = .location {
    didSet {
      eventItemChanged?(currentEventItem)
    }
  }

  var currentExpoItem: ExpoHeaderItem = .address {
    didSet {
      expoItemChanged?(currentExpoItem)
    }
  }

  var expoItemChanged: ((ExpoHeaderItem) -> Void)? = nil
  var eventItemChanged: ((EventHeaderItem) -> Void)? = nil

  func configure(item: PassCityFeedItem) {
    titleLabel.text = item.title
	toggleButton.setImage ( isActive ? #imageLiteral(resourceName: "iconNavbarClose") : #imageLiteral(resourceName: "handle"), for: .normal)
	descriptionLabel.text = (isActive && !item.fullDescription.isEmpty) ? item.fullDescription : item.description
    eventBeforeDateLabel.text = item.schedule.isEmpty ? item.dates : item.schedule
    dateLabel.text = item.dates
	backgroundImageView.kf.setImage(with: item.imgURL)

	ratingView.rating = item.reviews.rating
	backgroundImageView.kf.setImage(with: item.imgURL)
	commentsCountLabel.text = "\(item.reviews.qty)"
	distationLabel.text = item.distance
	dateLabel.text = item.schedule.isEmpty ? item.dates : item.schedule
	descriptionLabel.text = item.description
	eventBeforeView.isHidden = item.type != .event
	eventBeforeDateLabel.text = item.dates
  }

  func setup() {
	toggleButton.setImage ( isActive ? #imageLiteral(resourceName: "iconNavbarClose") : #imageLiteral(resourceName: "handle"), for: .normal)
    itemsStackView.arrangedSubviews.forEach { subview in
      itemsStackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
   switch  screenType! {
    case .event:
      EventHeaderItem.allValues.forEach { item in
        let view = GoBarHeaderItemView(title: item.name)
        view.handler = { [weak self] in
          self?.currentEventItem = item
        }

        headerItemViews.append(view)
        itemsStackView.addArrangedSubview(view)
      }
    case .expo:
      ExpoHeaderItem.allValues.forEach { item in
        let view = GoBarHeaderItemView(title: item.name)
        view.handler = { [weak self] in
          self?.currentExpoItem = item
        }

        headerItemViews.append(view)
        itemsStackView.addArrangedSubview(view)

      }
    }


  }
}
