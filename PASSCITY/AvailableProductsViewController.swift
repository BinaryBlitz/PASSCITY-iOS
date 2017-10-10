//
//  AvailableProductsViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AvailableProductsViewController: UITableViewController, AvailableProductsView {
  var presenter: AvailableProductsViewPresenter? = nil
  let loaderView = LoaderView()
  let backgroundLoaderView = LoaderView()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.fetchProducts()
  }

  var items: [PassCityProductShort] = []

  func setItems(_ items: [PassCityProductShort]) {
    self.items = items
    //tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
    tableView.backgroundView?.isHidden = false
    tableView.separatorStyle = isRefreshing ? .none : .singleLine
    tableView.reloadData()
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.backgroundView?.isHidden = false
      //tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AvailableProductsViewPresenter(view: self)
    let nib = UINib(nibName: "AvailableProductsTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: AvailableProductsTableViewCell.defaultReuseIdentifier)
    presenter?.fetchProducts()
    tableView.backgroundView = backgroundLoaderView
    refreshControl = UIRefreshControl()
    guard let refreshControl = refreshControl else { return }
    tableView.addSubview(refreshControl)
    refreshControl.addSubview(loaderView)
    loaderView <- Edges()
    loaderView.alpha = 0
    refreshControl.addTarget(self, action: #selector(refreshingChanged), for: .valueChanged)
  }

  func refreshingChanged() {
    loaderView.alpha = (refreshControl?.isRefreshing ?? false) ? 1 : 0
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AvailableProductsTableViewCell.defaultReuseIdentifier, for: indexPath) as! AvailableProductsTableViewCell
    cell.configure(product: items[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset

    if deltaOffset <= 0 {
      presenter?.fetchProducts()
    }
  }

}
