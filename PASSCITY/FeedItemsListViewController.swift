//
//  FeedItemsListViewController.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class FeedItemsListViewController: UITableViewController, UISearchResultsUpdating {
  let loaderFooterView = LoaderView(size: 64)

  var loadMoreStatus: Bool = false {
    didSet {
      loaderFooterView.alpha = loadMoreStatus ? 1 : 0
    }
  }

  var items: [PassCityFeedItemShort] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.separatorStyle = isRefreshing ? .none : .singleLine
      tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
      tableView.reloadData()
    }
  }

  var updateResultsHandler: ((String) -> Void)? = nil
  var loadMoreHandler: (() -> Void)? = nil
  var moreButtonHandler: ((Category) -> Void)? = nil

  override func viewDidLoad() {
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    tableView.backgroundColor = .white
    tableView.tableFooterView = UIView()
    ResultFeedItemTableViewCell.registerNib(in: tableView)
    tableView.separatorStyle = .singleLine
    loaderFooterView.alpha = 0
    tableView.tableFooterView = loaderFooterView
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count

  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ResultFeedItemTableViewCell.instance(tableView, indexPath)!
    cell.configure(items[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

  }

  func updateSearchResults(for searchController: UISearchController) {
    updateResultsHandler?(searchController.searchBar.text ?? "")
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
      loadMoreHandler?()
    }
  }

}
