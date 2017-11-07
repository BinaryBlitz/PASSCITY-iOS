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

  var tableView: UITableView? = nil

  var isActive: Bool = false {
    didSet {
      
      tableView?.beginUpdates()
      tableView?.endUpdates()
    }
  }
  
  @IBAction func footerButtonTapped(_ sender: Any) {
    isActive = !isActive
  }

  
  @IBOutlet var dateTimePlaceIcons: [UIImageView]!
  
  var headerItemViews: [GoBarHeaderItemView] = []

  var screenType: PassCityFeedItemType = .event {
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
    descriptionLabel.text = item.description
    eventBeforeDateLabel.text = item.schedule.isEmpty ? item.dates : item.schedule
    dateLabel.text = item.dates

  }

  func setup() {
    itemsStackView.arrangedSubviews.forEach { subview in
      itemsStackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
   switch  screenType {
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
