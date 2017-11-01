//
//  AudioguideCardItemsListTableView.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AudioguideCardItemsListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  var tour: MTGFullObject? = nil {
    didSet {
      reloadData()
    }
  }

  var updateLayoutHanlder: (() -> Void)? = nil

  init() {
    super.init(frame: CGRect.null, style: .plain)
    backgroundColor = .white
    delegate = self
    dataSource = self
    tableFooterView = UIView()
    AudioguideCardItemTableViewCell.register(in: self)
    separatorStyle = .singleLine
    self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tour?.content.first?.children.count ?? 0

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = AudioguideCardItemTableViewCell.instance(self, indexPath)!
    if let item = tour?.content.first?.children[indexPath.row] {
      cell.configure(index: indexPath.row, title: item.title, isNowPlaying: AudioguidesPlayer.instance.isPlaying(tourId: tour?.uuid ?? "", itemId: item.uuid))
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let item = tour?.content.first?.children[indexPath.row] {
      AudioguidesPlayer.instance.togglePlayAudioguide(tourId: tour?.uuid ?? "", itemId: item.uuid)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
        self?.reloadData()
        self?.updateLayoutHanlder?()
      }
    }
  }

}
