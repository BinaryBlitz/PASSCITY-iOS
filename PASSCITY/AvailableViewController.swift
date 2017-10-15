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

  var searchController: UISearchController!
  
  let mapViewController = AvailableMapViewController()
  let productsViewController = AvailableProductsViewController()
  let announcesViewController = AvailableAnnouncesViewController()

  var currentViewController: UIViewController? = nil {
    didSet {
      oldValue?.removeFromParentViewController()
      oldValue?.view.removeFromSuperview()
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
      
    }
  }

  override func viewDidLoad() {

    setupView()
    setupNavigationBar()

    currentViewController = mapViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }

  func setupView() {
    view.addSubview(headerView)
    view.addSubview(containerView)

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

  func setupNavigationBar() {
    let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarSearch"), style: .plain, target: self, action: #selector(searchButtonAction))
    let filtersItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarFilter"), style: .plain, target: self, action: #selector(searchButtonAction))
    navigationItem.rightBarButtonItems = [searchItem, filtersItem]
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb")))

    navigationItem.title = nil
  }

  func searchButtonAction() {

  }

  func filtersButtonAction() {

  }
}
