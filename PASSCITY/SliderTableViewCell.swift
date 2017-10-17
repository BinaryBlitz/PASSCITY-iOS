//
//  SliderTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SliderTableViewCell: UITableViewCell {
  let slider = UISlider()
  let leftLabel = UILabel()
  let middleLabel = UILabel()
  let rightLabel = UILabel()

  var value: Float {
    get {
      return slider.value
    }
    set {
      slider.value = newValue
    }
  }

  var handler: ((Float) -> Void)? = nil

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  init() {
    super.init(style: .default, reuseIdentifier: nil)
    setup()
  }

  func setup() {
    selectionStyle = .none
    addSubview(slider)
    addSubview(leftLabel)
    addSubview(middleLabel)
    addSubview(rightLabel)

    for label in [leftLabel, middleLabel, rightLabel] {
      label.font = UIFont.systemFont(ofSize: 15)
    }

    slider.thumbTintColor = UIColor.red
    slider.tintColor = UIColor.red

    slider <- [
      Top(15),
      Left(16),
      Right(16)
    ]

    leftLabel <- [
      Left(16),
      CenterY().to(middleLabel)
    ]

    middleLabel <- [
      CenterX(),
      Top(10).to(slider)
    ]

    rightLabel <- [
      Right(16),
      CenterY().to(middleLabel)
    ]

    slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
  }

  func sliderValueChanged() {
    handler?(slider.value)
  }
}
