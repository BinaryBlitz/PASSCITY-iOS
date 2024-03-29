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

private enum MenuOptions: Int {
  case share = 0
  case cancel

  var title: String {
    switch self {
    case .share:
      return "Поделиться"
    case .cancel:
      return "Отмена"
    }
  }

  var icon: UIImage {
    switch self {
    case .share:
      return #imageLiteral(resourceName: "iconMenuShare")
    case .cancel:
      return #imageLiteral(resourceName: "iconNavbarClose")
    }
  }

  static let allValues = [share, cancel]
}

class AvailableProductsViewController: UITableViewController, AvailableProductsView {
  var presenter: AvailableProductsViewPresenter? = nil
  let loaderView = LoaderView(size: 64)
  var loaderFooterView: LoaderView!
  let backgroundLoaderView = LoaderView()

  var searchController: UISearchController!

  var optionViews: [MenuOptionItemView] = MenuOptions.allValues.map { MenuOptionItemView(icon: $0.icon, title: $0.title )}

  var loadMoreStatus: Bool = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.fetchProducts()
    RootViewController.instance?.configureMenuView(items: optionViews, handler: nil)
  }

  var items: [PassCityProduct] = []

  func setItems(_ items: [PassCityProduct]) {
    self.items = items
    tableView.backgroundView?.isHidden = !items.isEmpty
    tableView.separatorStyle = items.isEmpty ? .none : .singleLine
    tableView.reloadData()
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AvailableProductsViewPresenter(view: self)
    AvailableProductsTableViewCell.registerNib(in: tableView)
    presenter?.fetchProducts()
    tableView.backgroundView = backgroundLoaderView
    loaderFooterView = LoaderView(size: 64, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
    tableView.tableFooterView = loaderFooterView
    loaderFooterView.alpha = 0
    refreshControl = UIRefreshControl()
    guard let refreshControl = refreshControl else { return }
    tableView.addSubview(refreshControl)
    refreshControl.addSubview(loaderView)
    loaderView <- Edges()
    loaderView.alpha = 0
    refreshControl.addTarget(self, action: #selector(refreshingChanged), for: .valueChanged)
    setupSearchController()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
  }

  func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.searchBar.searchBarStyle = .minimal
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.delegate = self
  }

  func refreshingChanged() {
    UIView.animate(withDuration: 0.8, animations: { [weak self] in
      self?.loaderView.alpha = 1
    }, completion: { [weak self] _ in
      self?.loadMoreStatus = true
      self?.presenter?.fetchProducts(reset: true) { [weak self] in
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
    cell.moreButtonHandler = {
      RootViewController.instance?.menuVisible = true
    }
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
    presenter?.didSelectProduct(items[indexPath.row])
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

extension AvailableProductsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    presenter?.searchText = searchController.searchBar.text ?? ""
  }

  func willDismissSearchController(_ searchController: UISearchController) {
    searchController.searchBar.text = ""
    presenter?.searchText = ""
    guard let parentVC = parent as? AvailableViewController else { return }
    parentVC.isSearching = false
  }

  func didPresentSearchController(_ searchController: UISearchController) {
    DispatchQueue.main.async {
      searchController.searchBar.becomeFirstResponder()
    }
  }
}
