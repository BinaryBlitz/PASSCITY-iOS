//
//  AddressCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

enum AddressItem: Int {
  case location = 0
  case subway
  case phone
  case link

  var emptyTitle: String {
    switch self {
    case .location:
      return "Адрес не указан"
    case .subway:
      return "Метро не указано"
    case .phone:
      return "Телефон не указан"
    case .link:
      return "Веб-сайт не указан"

    }
  }

  var image: UIImage {
    switch self {
    case .location:
      return #imageLiteral(resourceName: "iconAddress")
    case .subway:
      return #imageLiteral(resourceName: "iconMetro")
    case .phone:
      return #imageLiteral(resourceName: "iconPhone")
    case .link:
      return #imageLiteral(resourceName: "iconLink")

    }
  }

  static let allValues = [location, subway, phone, link]
}

class AddressCell: UITableViewCell {
  let addressesStackView = UIStackView()

  var handler: ((AddressItem) -> Void)? = nil

  var items: [DateItemView] {
    get {
      return addressesStackView.arrangedSubviews as? [DateItemView] ?? []
    }
    set {
      addressesStackView.arrangedSubviews.forEach { item in
        addressesStackView.removeArrangedSubview(item)
        item.removeFromSuperview()
      }
    }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    addressesStackView.axis = .vertical
    addressesStackView.spacing = 9
    for item in AddressItem.allValues {
      let view = DateItemView(item)
      view.handler = { [weak self] in
        self?.handler?(item)
      }
      addressesStackView.addArrangedSubview(view)
    }

    addressesStackView <- [
      Top(20),
      Left(20),
      Top(20),
      Bottom(20)
    ]
  }

  func configure(address: Address?, contacts: Contacts?) {
    guard let address = address, let contacts = contacts else { return }
    var items = self.items

    items[AddressItem.location.rawValue].text = address.city + ", " + address.street
    items[AddressItem.subway.rawValue].text = address.metro
    items[AddressItem.phone.rawValue].text = contacts.phone
    items[AddressItem.phone.rawValue].text = contacts.web?.path ?? ""
    self.items = items
  }
}


class DateItemView: UIView {
  var iconView = UIImageView()
  var titleLabel = UILabel()
  var handler: (() -> Void)? = nil

  var text: String? {
    get {
      return titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }

  init(_ item: AddressItem) {
    super.init(frame: CGRect.null)

    addSubview(iconView)
    addSubview(titleLabel)
    iconView.image = item.image
    titleLabel.text = item.emptyTitle

    titleLabel.numberOfLines = 0

    iconView <- [
      Top().to(iconView).when { self.titleLabel.frame.height > 14 },
      CenterY().to(iconView).when { self.titleLabel.frame.height <= 14 },
      Left().to(iconView)
    ]

    titleLabel <- [
      Top(),
      CenterY(),
      Left(),
      Bottom()
    ]

    isUserInteractionEnabled = true

    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemDidTap)))
  }

  func itemDidTap() {
    handler?()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
