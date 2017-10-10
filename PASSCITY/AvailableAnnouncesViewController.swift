//
//  AvailableAnnouncesViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

private enum MenuOptions: Int {
  case favorite = 0
  case mark
  case share
  case cancel

  var title: String {
    switch self {
    case .favorite:
      return "В избранное"
    case .mark:
      return "Оценить"
    case .share:
      return "Поделиться"
    case .cancel:
      return "Отмена"
    }
  }

  var icon: UIImage {
    switch self {
    case .favorite:
      return #imageLiteral(resourceName: "iconMenuFavorites")
    case .mark:
      return #imageLiteral(resourceName: "iconMenuRating")
    case .share:
      return #imageLiteral(resourceName: "iconMenuShare")
    case .cancel:
      return #imageLiteral(resourceName: "iconNavbarClose")
    }
  }

  static let allValues = [favorite, mark, share, cancel]
}

class AvailableAnnouncesViewController: UITableViewController, AvailableAnnouncesView {
  var presenter: AvailableAnnouncesViewPresenter? = nil

  let loaderView = LoaderView(size: 50)
  let loaderFooterView = LoaderView(size: 64)
  let backgroundLoaderView = LoaderView()

  var optionViews: [MenuOptionItemView] = MenuOptions.allValues.map { MenuOptionItemView(icon: $0.icon, title: $0.title )}

  var loadMoreStatus: Bool = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.fetchAnnounces()
    RootViewController.instance?.configureMenuView(items: optionViews, handler: nil)
  }

  var isExpandedItemId: Int? = nil

  var items: [PassCityFeedItemShort] = []

  func setItems(_ items: [PassCityFeedItemShort]) {
    self.items = items
    tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
    tableView.reloadData()
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
      tableView.reloadData()
    }
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    presenter = AvailableAnnouncesViewPresenter(view: self)
    let nib = UINib(nibName: "AvailableAnnouncesTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: AvailableAnnouncesTableViewCell.defaultReuseIdentifier)
      presenter?.fetchAnnounces()
    tableView.backgroundView = backgroundLoaderView
    tableView.tableFooterView = loaderFooterView
    loaderFooterView.alpha = 0
    refreshControl = UIRefreshControl()
    guard let refreshControl = refreshControl else { return }
    tableView.addSubview(refreshControl)
    refreshControl.addSubview(loaderView)
    loaderView <- Edges()
    loaderView.alpha = 0
    refreshControl.addTarget(self, action: #selector(refreshingChanged), for: .valueChanged)
  }

  func refreshingChanged() {
    UIView.animate(withDuration: 0.8, animations: { [weak self] in
      self?.loaderView.alpha = 1
      }, completion: { [weak self] _ in
        self?.loadMoreStatus = true
        self?.presenter?.fetchAnnounces(increasePage: false) { [weak self] in
          self?.loadMoreStatus = true
          UIView.animate(withDuration: 0.8, animations: {
            self?.loaderView.alpha = 0
          }, completion: { [weak self] _ in
            self?.refreshControl?.endRefreshing()
          })
        }
    })

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
    let item = items[indexPath.row]
    cell.configure(item: item)
    cell.isExpanded = item.id == isExpandedItemId
    cell.isExpandedHandler = { [weak self] isExpanded in
      self?.isExpandedItemId = isExpanded ? item.id : nil
      tableView.beginUpdates()
      tableView.endUpdates()
    }
    cell.moreButtonHandler = {
      RootViewController.instance?.menuVisible = true
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return isExpandedItemId == items[indexPath.row].id ? 419 : 275
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return isExpandedItemId == items[indexPath.row].id ? 419 : 275
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset

    if deltaOffset <= 0 {
      loadMore()
    }
  }

  func loadMore() {
    if !loadMoreStatus {
      loadMoreStatus = true
      loaderFooterView.alpha = 1
      presenter?.fetchAnnounces() { [weak self] in
        self?.loadMoreStatus = false
        self?.loaderFooterView.alpha = 0
      }

    }
  }


}
