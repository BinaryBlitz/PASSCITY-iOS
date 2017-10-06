//
//  AvailableAnnouncesViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class AvailableAnnouncesViewController: UITableViewController, AvailableAnnouncesView {
  var presenter: AvailableAnnouncesViewPresenter? = nil

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.fetchAnnounces()
  }

  var items: [PassCityFeedItemShort] = []

  func setItems(_ items: [PassCityFeedItemShort]) {
    self.items = items
    tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AvailableAnnouncesViewPresenter(view: self)
    let nib = UINib(nibName: "AvailableAnnouncesTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: AvailableAnnouncesTableViewCell.defaultReuseIdentifier)
    presenter?.fetchAnnounces()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AvailableAnnouncesTableViewCell.defaultReuseIdentifier, for: indexPath) as! AvailableAnnouncesTableViewCell
    cell.configure(item: items[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 275
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset

    if deltaOffset <= 0 {
      presenter?.fetchAnnounces()
    }
  }

}
