//
//  AudioguideCardPlayingItemMarkerView.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AudioguideCardPlayingItemMarkerView: UIView {
  let dotOuterView = UIView()
  let dotInnerView = UIView()
  let dotLabel = UILabel()

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    backgroundColor = .clear
    dotOuterView.backgroundColor = .seafoamBlue
    dotInnerView.backgroundColor = .white
    dotLabel.font = UIFont.systemFont(ofSize: 10)

    addSubview(dotOuterView)

    dotOuterView <- [
      Size(22),
      Center()
    ]
    dotOuterView.cornerRadius = 11

    dotOuterView.addSubview(dotInnerView)

    dotInnerView <- [
      Size(16),
      Center()
    ]
    dotInnerView.cornerRadius = 8

    dotInnerView.addSubview(dotLabel)

    dotLabel <- [
      Center()
    ]

  }

  func configure(index: Int, isPlaying: Bool) {
    dotLabel.text = "\(index + 1)"
    if isPlaying {
      dotOuterView <- Size(24)
      dotOuterView.cornerRadius = 12
      dotInnerView.backgroundColor = .clear
      dotLabel.textColor = .white
    } else {
      dotOuterView <- Size(22)
      dotOuterView.cornerRadius = 11
      dotInnerView.backgroundColor = .white
      dotLabel.textColor = .black
    }
  }
}
