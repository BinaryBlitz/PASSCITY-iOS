//
//  AudioguideCardItemTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AudioguideCardItemTableViewCell: UITableViewCell {
  let dotOuterView = UIView()
  let dotInnerView = UIView()
  let dotLabel = UILabel()
  let titleLabel = UILabel()
  let soundbarsIconView = UIImageView(image: #imageLiteral(resourceName: "iconSoundbars"))

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    dotOuterView.backgroundColor = .seafoamBlue
    dotInnerView.backgroundColor = .white
    dotLabel.font = UIFont.systemFont(ofSize: 10)
    titleLabel.font = UIFont.systemFont(ofSize: 14)

    addSubview(dotOuterView)
    dotOuterView.cornerRadius = 11
    dotOuterView <- [
      Left(20),
      Size(22),
      CenterY()
    ]

    dotOuterView.addSubview(dotInnerView)

    dotInnerView.cornerRadius = 8
    dotInnerView <- [
      Size(16),
      Center()
    ]

    dotInnerView.addSubview(dotLabel)

    dotLabel <- [
      Center()
    ]

    addSubview(soundbarsIconView)

    soundbarsIconView <- [
      Right(20).with(.high),
      Size(20),
      CenterY()
    ]

    addSubview(titleLabel)
    titleLabel.numberOfLines = 2

    titleLabel <- [
      Top(18),
      Bottom(18),
      Left(20).to(dotOuterView),
      Right(5).to(soundbarsIconView)
    ]

    soundbarsIconView.isHidden = true
  }

  func configure(index: Int, title: String, isNowPlaying: Bool) {
    titleLabel.text = title
    dotLabel.text = "\(index + 1)"
    soundbarsIconView.isHidden = !isNowPlaying
    if isNowPlaying {
      dotOuterView <- Size(24)
      dotInnerView.backgroundColor = .clear
      dotLabel.textColor = .white
    } else {
      dotOuterView <- Size(22)
      dotOuterView.cornerRadius = 11
      dotInnerView.backgroundColor = .white
      dotLabel.textColor = .black
    }
    layoutIfNeeded()
    updateConstraintsIfNeeded()
  }
}
