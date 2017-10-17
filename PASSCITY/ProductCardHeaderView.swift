//
//  ProductCardHeaderView.swift
//  PASSCITY
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

enum ProductCardHeaderItem: Int {
  case items = 0
  case conditions
  case offer

  var title: String {
    switch self {
    case .items:
      return NSLocalizedString("productCardHeaderItems", comment: "Product card header")
    case .conditions:
      return NSLocalizedString("productCardHeaderConditions", comment: "Product card header")
    case .offer:
      return NSLocalizedString("productCardHeaderOffer", comment: "Product card header")
    }
  }

  static let allItems = [items, conditions, offer]
}

class ProductCardHeaderView: UIView {
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var productIconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet var iconViews: [UIImageView]!
  @IBOutlet weak var tariffLabel: UILabel!
  @IBOutlet weak var validLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var itemsView: UIStackView!

  var headerItemViews: [TopBarHeaderItemView] = []

  var itemChangedHandler: ((ProductCardHeaderItem) -> Void)? = nil

  var currentItem: ProductCardHeaderItem = .items {
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

    iconViews.forEach { $0.image = $0.image?.withRenderingMode(.alwaysTemplate) }
    ProductCardHeaderItem.allItems.forEach { item in
      let view = TopBarHeaderItemView(title: item.title)
      view.handler = { [weak self] in
        self?.currentItem = item
      }

      itemsView.addArrangedSubview(view)
      headerItemViews.append(view)
    }
    headerItemViews[ProductCardHeaderItem.items.rawValue].isSelected = true
  }

  func configure(_ product: PassCityProduct) {
    titleLabel.text = product.title
    tariffLabel.text = product.tariff
    validLabel.text = String(product.valid.replacingOccurrences(of: "\t", with: " ", options: [], range: nil))
    priceLabel.text = product.price.currencyString
    productIconView.kf.setImage(with: product.categoryObject?.icon)
    backgroundImageView.kf.setImage(with: product.imgs.first)
  }
}
