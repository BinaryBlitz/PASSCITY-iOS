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
  let loaderView = LoaderView(size: 64)
  let loaderFooterView = LoaderView(size: 64)
  let backgroundLoaderView = LoaderView()

  var loadMoreStatus: Bool = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.fetchProducts()
  }

  var items: [PassCityProductShort] = []

  func setItems(_ items: [PassCityProductShort]) {
    self.items = items
    tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
    tableView.separatorStyle = isRefreshing ? .none : .singleLine
    tableView.reloadData()
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.separatorStyle = isRefreshing ? .none : .singleLine
      tableView.backgroundView?.isHidden = !isRefreshing || !items.isEmpty
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AvailableProductsViewPresenter(view: self)
    let nib = UINib(nibName: "AvailableProductsTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: AvailableProductsTableViewCell.defaultReuseIdentifier)
    presenter?.fetchProducts()
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
      self?.presenter?.fetchProducts(increasePage: false) { [weak self] in
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
      loadMore()
    }
  }

  func loadMore() {
    if !loadMoreStatus {
      loadMoreStatus = true
      loaderFooterView.alpha = 1
      presenter?.fetchProducts() { [weak self] in
        self?.loadMoreStatus = false
        self?.loaderFooterView.alpha = 0
      }
      
    }
  }

}
