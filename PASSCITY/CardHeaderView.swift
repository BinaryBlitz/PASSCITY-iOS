//
//  CardHeaderView.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

enum CardScreenItem: Int {
  case owner = 0
  case bonus
  case promoCode
  case balance

  var title: String {
    switch self {
    case .owner:
      return "Владелец"
    case .bonus:
      return "Бонусы"
    case .promoCode:
      return "Промо-код"
    case .balance:
      return "Баланс"
    }
  }

  var image: UIImage {
    switch self {
    case .owner:
      return #imageLiteral(resourceName: "iconMenubarOwner")
    case .bonus:
      return #imageLiteral(resourceName: "iconMenubarBonus")
    case .promoCode:
      return #imageLiteral(resourceName: "iconMenubarPromo")
    case .balance:
      return #imageLiteral(resourceName: "iconMenubarBalance")
    }
  }

  static let allItems = [owner, bonus, promoCode, balance]
}

class CardHeaderView: UIView {
  @IBOutlet weak var cardNumberLabel: UILabel!
  @IBOutlet weak var iconArrowView: UIImageView!
  @IBOutlet weak var menuItemsView: UIStackView!
  @IBOutlet weak var cardBackgroundView: UIView!
  
  var headerItemViews: [CardOptionView] = []

  var itemChangedHandler: ((CardScreenItem) -> Void)? = nil

  var currentItem: CardScreenItem = .owner {
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
    iconArrowView.image = iconArrowView.image?.withRenderingMode(.alwaysTemplate)
    
    CardScreenItem.allItems.forEach { item in
      let view = CardOptionView()
      view.configure(icon: item.image, title: item.title)
      view.handler = { [weak self] in
        self?.currentItem = item
      }

      menuItemsView.addArrangedSubview(view)
      headerItemViews.append(view)
    }
    
    headerItemViews[ProductCardHeaderItem.items.rawValue].isSelected = true

  }

  func configure(card: PassCityCard) {
    guard !card.code.characters.isEmpty else { return }
    var title = "\(card.code.characters.first!)"
    title += "  "

    if card.code.characters.count > 6 {
      title += card.code.substring(with: card.code.index(card.code.startIndex, offsetBy: 1)..<card.code.index(card.code.startIndex, offsetBy: 7))
      title += "  \(card.code.substring(with: card.code.index(card.code.startIndex, offsetBy: 7)..<card.code.endIndex))"
    } else {
      title += card.code.substring(with: card.code.index(card.code.startIndex, offsetBy: 1)..<card.code.endIndex)
    }


    cardNumberLabel.text = title
  }
}
