//
//  AvailableViewController.swift
//  PASSCITY
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

enum AvailableHeaderItem: Int {
  case map = 0
  case announces
  case products

  var title: String {
    switch self {
    case .map:
      return NSLocalizedString("availableHeaderMapItem", comment: "Available header")
    case .announces:
      return NSLocalizedString("availableAnnouncesMapItem", comment: "Available header")
    case .products:
      return NSLocalizedString("availableProductsMapItem", comment: "Available header")
    }
  }

  static let allItems = [map, announces, products]
}

class AvailableViewController: UIViewController {
  let headerView = UIStackView()
  var headerItemViews: [TopBarHeaderItemView] = []
  let containerView = UIView()
  let mapViewController = AvailableMapViewController()
  let productsViewController = AvailableProductsViewController()
  let announcesViewController = AvailableAnnouncesViewController()

  var currentViewController: UIViewController? = nil {
    didSet {
      oldValue?.removeFromParentViewController()
      oldValue?.view.removeFromSuperview()
      setupNavigationBar()
      guard let newViewController = currentViewController else { return }

      addChildViewController(newViewController)
      containerView.addSubview(newViewController.view)
      newViewController.view <- Edges()
      newViewController.didMove(toParentViewController: self)
    }
  }

  var currentItem: AvailableHeaderItem = .map {
    didSet {
      headerItemViews.enumerated().forEach { index, view in
        view.isSelected = currentItem.rawValue == index
      }
      switch currentItem {
      case .map:
        currentViewController = mapViewController
      case .announces:
        currentViewController = announcesViewController
      case .products:
        currentViewController = productsViewController
      }
    }
  }

  var isSearching: Bool = false {
    didSet {
      if isSearching {
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.setImage(#imageLiteral(resourceName: "iconNavbarSearchCopy"), for: .search, state: .normal)

        navigationItem.rightBarButtonItems = []
        navigationItem.leftBarButtonItem = nil
        if #available(iOS 11.0, *) {
          searchController.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.changeSearchBarColor(color: UIColor.clear)
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(5.0, 0.0)
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        navigationController?.navigationBar.layoutIfNeeded()
      } else {
        setupNavigationBar()
      }
    }
  }

  var searchController: UISearchController {
    switch currentItem {
    case .announces:
      return announcesViewController.searchController
    case .products:
      return productsViewController.searchController
    case .map:
      return mapViewController.searchController
    }
  }

  override func viewDidLoad() {

    setupView()
    setupNavigationBar()

    currentViewController = mapViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MainTabBarController.instance.tabBarHidden = false
    containerView <- [
      Top().to(headerView),
      Bottom(MainTabBarController.instance.playerWidgetHeight).to(bottomLayoutGuide),
      Left(),
      Right()
    ]
  }

  func setupView() {
    view.addSubview(headerView)
    view.addSubview(containerView)

    definesPresentationContext = true

    headerView.axis = .horizontal
    headerView.distribution = .fillEqually
    
    AvailableHeaderItem.allItems.forEach { item in
      let view = TopBarHeaderItemView(title: item.title)
      view.handler = { [weak self] in
        self?.currentItem = item
      }
      headerView.addArrangedSubview(view)
      headerItemViews.append(view)
    }

    headerItemViews[AvailableHeaderItem.map.rawValue].isSelected = true

    headerView <- [
      Top().to(topLayoutGuide),
      Left(),
      Right(),
      Height(46)
    ]

    containerView <- [
      Top().to(headerView),
      Bottom().to(bottomLayoutGuide),
      Left(),
      Right()
    ]
  }

  private func setupNavigationBar() {
    let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarSearch"), style: .plain, target: self, action: #selector(searchButtonAction))
    let filtersItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarFilter"), style: .plain, target: self, action: #selector(filtersButtonAction))

    navigationItem.rightBarButtonItems = [searchItem, filtersItem]
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb")))
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    navigationItem.titleView = nil
    navigationItem.title = nil
  }

  func searchButtonAction() {
    isSearching = true
  }

  func filtersButtonAction() {
    switch currentItem {
    case .announces:
      let viewController = FeedItemsFilterViewController()
      viewController.filters = announcesViewController.presenter?.currentFilters.filter
      viewController.handler = { [weak self] filters -> Void in
        self?.announcesViewController.presenter?.currentFilters.filter = filters
        return
      }
      navigationController?.pushViewController(viewController, animated: true)
    case .products:
      let viewController = ProductsFiltersViewController()
      viewController.filters = productsViewController.presenter?.currentFilters.filter
      viewController.handler = { [weak self] filters -> Void in
        self?.productsViewController.presenter?.currentFilters.filter = filters
        return
      }
      navigationController?.pushViewController(viewController, animated: true)
    case .map:
      let viewController = FeedItemsFilterViewController()
      viewController.filters = mapViewController.presenter?.currentFilters.filter
      viewController.handler = { [weak self] filters -> Void in
        self?.mapViewController.presenter?.currentFilters.filter = filters
        return
      }
      navigationController?.pushViewController(viewController, animated: true)
    }

  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard isSearching else { return }
    searchController.searchBar.sizeToFit()
  }

}

extension UISearchBar {
  func changeSearchBarColor(color: UIColor) {
    UIGraphicsBeginImageContext(self.frame.size)
    color.setFill()
    UIBezierPath(rect: self.frame).fill()
    let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    self.setSearchFieldBackgroundImage(bgImage, for: .normal)
  }
}
