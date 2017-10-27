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
      return #imageLiteral(resourceName: "iconMenubarRecords")
    case .map:
      return #imageLiteral(resourceName: "iconMenubarOnmap")
    case .download:
      return #imageLiteral(resourceName: "iconMenubarDownload")
    case .autoplay:
      return #imageLiteral(resourceName: "iconMenubarAutoplay")
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

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBAction func rateButtonAction(_ sender: Any) {
  }

  @IBAction func shareButtonAction(_ sender: Any) {
  }

  var headerItemViews: [CardOptionView] = []

  var itemChangedHandler: ((AudioguideScreenItem) -> Void)? = nil

  var downloadHandler: (() -> Void)? = nil

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
        switch item {
        case .autoplay:
          view.isSelected = !view.isSelected
          AudioguidesPlayer.instance.autoPlay = view.isSelected
        case .download:
          self?.downloadHandler?()
          view.alpha = 0.8
          view.button.isEnabled = false
        default:
          self?.currentItem = item
        }
      }

      itemsView.addArrangedSubview(view)
      headerItemViews.append(view)
    }

    headerItemViews[AudioguideScreenItem.list.rawValue].isSelected = true
    headerItemViews[AudioguideScreenItem.autoplay.rawValue].isSelected = AudioguidesPlayer.instance.autoPlay
  }



  func configure(_ item: MTGObject) {
    headerItemViews[AudioguideScreenItem.download.rawValue].iconButton.setImage(!item.isDownloaded ? #imageLiteral(resourceName: "iconMenubarDownload") : #imageLiteral(resourceName: "iconMenubarDownloadDel"), for: .normal)

    headerItemViews[AudioguideScreenItem.download.rawValue].alpha = AudioguidesPlayer.instance.downloadingToursIds.index(of: item.uuid) == nil ? 0.8 : 1.0

    var contentItem: MTGChildObject? = nil
    if let childObject = item as? MTGChildObject {
      contentItem = childObject
      let distanceFormatter = NumberFormatter()
      distanceFormatter.maximumFractionDigits = 2
      let distanceString = distanceFormatter.string(from: NSNumber(value: Float(childObject.distance) / 1000)) ?? ""
      distanceLabel.text = "\(distanceString) км"
    } else if let fullObject = item as? MTGFullObject {
      guard let content = fullObject.content.first else { return }
      contentItem = content
    }
    guard contentItem != nil else { return }
    titleLabel.text = contentItem!.title
    if let image = contentItem!.images.first {
      let url = "https://media.izi.travel/\(item.contentProviderId)/\(image.uuid)_800x600.jpg"
      backgroundImageView.kf.setImage(with: URL(string: url))
    }
    durationLabel.text = TimeInterval(contentItem!.duration).toString
  }

}
