//
//  ProductCardItemTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy


class ProductCardItemTableViewCell: UITableViewCell {
  let cardView = PasscityMapCardView.nibInstance()!

  var moreHandler: (() -> Void)? {
    get {
      return cardView.buttonHandler
    }
    set {
      cardView.buttonHandler = newValue
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
    addSubview(cardView)
    cardView.button.setImage(#imageLiteral(resourceName: "iconMenuBig"), for: .normal)
    cardView.backgroundColor = UIColor.clear
    cardView <- Edges()
  }

  func configure(_ item: PassCityFeedItem) {
    cardView.configure(item: item)
    cardView.layoutIfNeeded()
  }
}
