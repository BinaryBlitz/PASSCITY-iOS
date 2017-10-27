//
//  AudioguidesListViewController.swift
//  PASSCITY
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AudioguidesListViewController: UITableViewController {
  var guides: [MTGChildObject] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    AudioguidesListTableViewCell.register(in: tableView)
    title = "Аудиоэкскурсии"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false

    self.guides = AudioguidesService.instande.sortedTours
    AudioguidesService.instande.fetchAudioguidesList { result in
      switch result {
      case .success(let guides):
        self.guides = guides
      case .failure(_):
        break
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return guides.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = AudioguidesListTableViewCell.instance(tableView, indexPath)!
    let guide = guides[indexPath.row]
    
    cell.configure(guide, isPlaying: AudioguidesPlayer.instance.isPlaying(tourId: guide.uuid) && AudioguidesPlayer.instance.playing, status: AudioguidesPlayer.instance.downloadingStatus(guide))
    cell.playHandler = { [weak self] in
      AudioguidesPlayer.instance.togglePlayAudioguide(tourId: guide.uuid)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self?.tableView.reloadData()
        self?.updateLayout()
      }
    }
    return cell
  }

  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateLayout()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let viewController = AudioguideCardViewController()
    viewController.shortTour = guides[indexPath.row]
    navigationController?.pushViewController(viewController, animated: true)
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
