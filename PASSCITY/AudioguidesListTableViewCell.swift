//
//  AudioguidesListTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AudioguidesListTableViewCell: UITableViewCell {
  let circleView = UIButton(type: .system)
  let playButton = UIButton(type: .system)
  let donwnloadButton = UIButton(type: .system)
  let titleView = UIView()

  let titleLabel = UILabel()
  let clockIconView = UIImageView(image: #imageLiteral(resourceName: "iconClock"))
  let durationLabel = UILabel()

  var playHandler: (() -> Void)? = nil
  var downloadHandler: (() -> Void)? = nil

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    circleView.backgroundColor = UIColor.red
    circleView.cornerRadius = 20
    addSubview(circleView)
    circleView <- [
      Size(40),
      CenterY(),
      Left(20)
    ]

    playButton.setImage(#imageLiteral(resourceName: "iconPlayerPlay").withRenderingMode(.alwaysTemplate), for: .normal)
    playButton.tintColor = UIColor.white
    playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    circleView.addSubview(playButton)
    playButton <- Edges()

    addSubview(titleView)

    titleView <- [
      Left(20).to(circleView),
      //CenterY(),
      Top(20),
      Bottom(20)
    ]

    titleLabel.numberOfLines = 2
    titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
    titleView.addSubview(titleLabel)
    titleLabel <- [
      Left(),
      Top(),
      Right()
    ]

    titleView.addSubview(clockIconView)
    clockIconView.contentMode = .scaleAspectFit
    clockIconView <- [
      Left(),
      Top(8).to(titleLabel)
    ]

    durationLabel.font = UIFont.systemFont(ofSize: 12)
    durationLabel.textColor = UIColor.warmGrey
    titleView.addSubview(durationLabel)
    durationLabel <- [
      Left(7).to(clockIconView),
      Top(8).to(titleLabel),
      CenterY().to(clockIconView),
      Bottom()
    ]

    donwnloadButton.setImage(#imageLiteral(resourceName: "iconDownload"), for: .normal)
    donwnloadButton.tintColor = .black
    addSubview(donwnloadButton)
    playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    donwnloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)

    donwnloadButton <- [
      Size(40),
      CenterY(),
      Left(5).to(titleView),
      Right(20)
    ]
  }

  func configure(_ item: MTGChildObject, isPlaying: Bool, status: DownloadingStatus) {
    titleLabel.text = item.title
    durationLabel.text = TimeInterval(item.duration).toString
    playButton.setImage(!isPlaying ? #imageLiteral(resourceName: "iconPlayerPlay") : #imageLiteral(resourceName: "iconPlayerPause"), for: .normal)
    playButton.isEnabled = true
    
    switch status {
    case .downloaded:
      donwnloadButton.isEnabled = true
      donwnloadButton.setImage(#imageLiteral(resourceName: "iconNavbarClose"), for: .normal)
      donwnloadButton <- [
        Size(40)
      ]
    case .downloading:
      donwnloadButton.isEnabled = false
      donwnloadButton.setImage(nil, for: .normal)
      donwnloadButton.setTitle("Загружаю", for: .normal)
      donwnloadButton <- [
        Size(40)
      ]
    case .notDownloaded:
      donwnloadButton.isEnabled = true
      donwnloadButton.setImage(#imageLiteral(resourceName: "iconDownload"), for: .normal)
      donwnloadButton <- [
        Size(40)
      ]

    }
  }

  func playButtonAction() {
    playButton.isEnabled = false
    playHandler?()
  }

  func downloadButtonAction() {
    downloadHandler?()
  }
}
