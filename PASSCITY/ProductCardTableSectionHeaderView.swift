//
//  ProductCardTableSectionHeaderView.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

class ProductCardTableSectionHeaderView: UITableViewHeaderFooterView {
  let iconView = UIImageView()
  let circleView = UIView()
  let titleLabel = UILabel()
  let arrowView = UIImageView(image: #imageLiteral(resourceName: "iconArrowUp"))
  let button = UIButton()

  var handler: (() -> Void)? = nil

  var isActive: Bool = false {
    didSet {
      guard isActive != oldValue else { return }
      UIView.animate(withDuration: 0.2) { [weak self] in
        self?.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
      }
    }
  }

  func configure(category: Category) {
    iconView.kf.setImage(with: category.icon)
    circleView.backgroundColor = category.color
    titleLabel.text = category.title
  }

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    let view = UIView()
    backgroundView = view

    view.addSubview(circleView)

    circleView.cornerRadius = 15
    circleView <- [
      Size(30),
      CenterY(),
      Left(20)
    ]

    circleView.addSubview(iconView)
    iconView.tintColor = UIColor.white
    iconView.contentMode = .scaleAspectFit

    iconView <- [
      Center(),
      Edges(>=3)
    ]

    titleLabel.numberOfLines = 3
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
    titleLabel.textAlignment = .left

    view.addSubview(titleLabel)
    titleLabel <- [
      CenterY(),
      Left(15).to(circleView)
    ]

    view.addSubview(arrowView)
    arrowView <- [
      CenterY(),
      Right(20)
    ]

    addSubview(button)

    button.setTitle("", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    button <- [
      Edges()
    ]

  }
  
  func buttonAction() {
    handler?()
  }
}
