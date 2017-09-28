//
//  CardTableViewCell.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

class CardTableViewCell: UITableViewCell {
  let cardView = UIView()
  let backgroundImageView = UIImageView()
  let maskView = UIView()
  let disclosureIndicatorView = UIImageView(image: #imageLiteral(resourceName: "iconArrowDisclosure").withRenderingMode(.alwaysTemplate))
  let titleLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override var cornerRadius: CGFloat {
    get {
      return cardView.cornerRadius
    }
    set {
      cardView.cornerRadius = newValue
      backgroundImageView.cornerRadius = newValue
    }
  }

  func setup() {
    contentView.backgroundColor = UIColor.clear
    selectionStyle = .none
    cardView.clipsToBounds = true
    cardView.cornerRadius = 8
    cardView.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    maskView.backgroundColor = UIColor.clear

    backgroundImageView.clipsToBounds = true
    backgroundImageView.cornerRadius = 8
    backgroundImageView.contentMode = .scaleAspectFill

    disclosureIndicatorView.tintColor = UIColor.white

    addConstraints()
  }

  func addConstraints() {
    contentView.addSubview(cardView)

    cardView <- [
      Left(20),
      Right(20),
      Height(>=100),
      Top(5),
      Bottom(5)
    ]

    cardView.addSubview(backgroundImageView)
    cardView.addSubview(titleLabel)
    cardView.addSubview(disclosureIndicatorView)
    cardView.addSubview(maskView)

    backgroundImageView <- [
      Edges()
    ]

    titleLabel <- [
      LeftMargin(),
      TopMargin(>=0),
      BottomMargin(>=0),
      CenterY()
    ]

    disclosureIndicatorView <- [
      Left(>=5).to(titleLabel),
      RightMargin(),
      CenterY()
    ]

    maskView <- [
      Edges()
    ]

  }

  func configure(data: RegistrationTypeCellData) {
    titleLabel.attributedText = data.title
    backgroundImageView.image = data.image
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: true)
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.maskView.backgroundColor = selected ? UIColor.white.withAlphaComponent(0.2) : UIColor.clear
    }
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: true)
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.maskView.backgroundColor = highlighted ? UIColor.white.withAlphaComponent(0.2) : UIColor.clear
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    backgroundImageView.kf.cancelBackgroundTask()
  }
}
