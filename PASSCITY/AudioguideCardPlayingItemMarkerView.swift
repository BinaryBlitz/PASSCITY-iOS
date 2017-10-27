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
      Left(20),
      Size(22),
      CenterY()
    ]

    dotOuterView.addSubview(dotInnerView)

    dotInnerView <- [
      Size(16),
      Center()
    ]

    dotInnerView.addSubview(dotLabel)

    dotLabel <- [
      Center()
    ]

  }

  func configure(index: Int, isPlaying: Bool) {
    dotLabel.text = "\(index + 1)"
    if isPlaying {
      dotOuterView <- Size(24)
      dotInnerView.backgroundColor = .clear
      dotLabel.textColor = .white
    } else {
      dotOuterView <- Size(22)
      dotInnerView.backgroundColor = .white
      dotLabel.textColor = .black
    }
  }
}
