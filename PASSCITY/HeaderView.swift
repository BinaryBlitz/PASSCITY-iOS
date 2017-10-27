//
//  HeaderView.swift
//  PASSCITY
//
//  Created by Алексей on 22.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import FloatRatingView

enum AudioguideScreenItem: Int {
  case list = 0
  case map
  case download
  case autoplay

  var title: String {
    switch self {
    case .list:
      return "Записи"
    case .map:
      return "На карте"
    case .download:
      return "Скачать"
    case .autoplay:
      return "Автоплей"
    }
  }

  var image: UIImage {
    switch self {
    case .list:
      return #imageLiteral(resourceName: "iconMenubarOwner")
    case .map:
      return #imageLiteral(resourceName: "iconMenubarBonus")
    case .download:
      return #imageLiteral(resourceName: "iconMenubarPromo")
    case .autoplay:
      return #imageLiteral(resourceName: "iconMenubarBalance")
    }
  }

  static let allItems = [list, map, download, autoplay]
}


class AudioguideCardHeaderView: UIView {
  @IBOutlet weak var itemsView: UIStackView!
  @IBOutlet weak var ratingView: FloatRatingView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var rateButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!

  @IBAction func rateButtonAction(_ sender: Any) {
  }

  @IBAction func shareButtonAction(_ sender: Any) {
  }

  var headerItemViews: [CardOptionView] = []

  var itemChangedHandler: ((AudioguideScreenItem) -> Void)? = nil

  var currentItem: AudioguideScreenItem = .list {
    didSet {
      guard currentItem != oldValue else { return }
      itemChangedHandler?(currentItem)
      headerItemViews.enumerated().forEach { index, view in
        view.isSelected = currentItem.rawValue == index
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    AudioguideScreenItem.allItems.forEach { item in
      let view = CardOptionView()
      view.configure(icon: item.image, title: item.title)
      view.handler = { [weak self] in
        self?.currentItem = item
      }

      itemsView.addArrangedSubview(view)
      headerItemViews.append(view)
    }

    headerItemViews[AudioguideScreenItem.list.rawValue].isSelected = true

  }



  func configure(_ item: MTGObject) {
    var contentItem: MTGChildObject? = nil
    if let childObject = item as? MTGChildObject {
      contentItem = childObject
    } else if let fullObject = item as? MTGFullObject {
      guard let content = fullObject.content.first else { return }
      contentItem = content
    }
    guard let item = contentItem else { return }
    titleLabel.text = item.title
    durationLabel.text = TimeInterval(item.duration * 60).toString
    let distanceFormatter = NumberFormatter()
    distanceFormatter.maximumFractionDigits = 2
    distanceLabel.text = "\(distanceFormatter.string(from: NSNumber(value: Float(item.distance) / 1000))) км"
  }

}
