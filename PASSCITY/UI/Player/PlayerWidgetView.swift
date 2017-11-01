//
//  PlayerWidgetView.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class PlayerWidgetView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var trackIndexLabel: UILabel!
  @IBOutlet weak var timeOffsetLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var offsetWidthConstraint: NSLayoutConstraint!

  var playButtonHandler: (() -> Void)? = nil
  var pauseButtonHandler: (() -> Void)? = nil

  var title: String? = nil {
    didSet {
      titleLabel.text = title
    }
  }

  var index: Int? = nil {
    didSet {
      trackIndexLabel.text = index != nil ? "\(index! + 1)" : ""
    }
  }

  var duration: Double = 0 {
    didSet {
      durationLabel.text = TimeInterval(duration).toString
      offsetWidthConstraint.constant = duration != 0 ? frame.width * CGFloat(offset/duration) : 0
    }
  }

  var isPlaying: Bool = false {
    didSet {
      playButton.setImage(isPlaying ? #imageLiteral(resourceName: "iconPlayerPause") : #imageLiteral(resourceName: "iconPlayerPlay"), for: .normal)
    }
  }

  var offset: Double = 0 {
    didSet {
      timeOffsetLabel.text = TimeInterval(offset).toString
      offsetWidthConstraint.constant = duration != 0 ? frame.width * CGFloat(offset/duration) : 0
      if offsetWidthConstraint.constant >= timeOffsetLabel.frame.width + 4 {
        timeOffsetLabel.textColor = UIColor.white
      } else {
        timeOffsetLabel.textColor = UIColor.black
      }
    }
  }

  @IBAction func playButtonAction(_ sender: Any) {
    AudioguidesPlayer.instance.togglePlay()
  }

  @IBAction func forwardButtonAction(_ sender: Any) {
    AudioguidesPlayer.instance.playNextTrackIfPossible()
  }

  @IBAction func playerTapAction(_ sender: Any) {
  }
  
}
