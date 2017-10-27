//
//  ProductCardViewController.swift
//  PASSCITY
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import WebKit

class ProductCardViewController: UIViewController, ProductCardView, LightContentViewController, TransparentViewController {
  var presenter: ProductCardViewPresenter!
  let headerView = ProductCardHeaderView.nibInstance()!
  let containerView = UIView()
  let loaderView = LoaderView()

  let itemsTableView = ProductCardItemsTableView()
  let conditionsTableView = ProductCardConditionsTableView()
  let offerView = WKWebView()

  var optionViews: [MenuOptionItemView] = AnnouncesMenuOptions.allValues.map { MenuOptionItemView(icon: $0.icon, title: $0.title )}

  var currentItem: ProductCardHeaderItem = .items {
    didSet {
      headerView.currentItem = currentItem

      guard currentItem != oldValue else { return }
      switch currentItem {
      case .items:
        currentView = itemsTableView
      case .conditions:
        currentView = conditionsTableView
      case .offer:
        currentView = offerView
      }
    }
  }

  var product: PassCityProduct? = nil {
    didSet {
      guard let product = product else { return }
      headerView.configure(product)
      itemsTableView.items = product.categories
      conditionsTableView.items = product.categories
      guard let offerUrl = product.offer else { return }
      offerView.load(URLRequest(url: offerUrl))
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      loaderView.isHidden = !isRefreshing
    }
  }

  var currentView: UIView? = nil {
    didSet {
      oldValue?.isHidden = true
      oldValue?.removeFromSuperview()

      guard let newView = currentView else { return }
      containerView.addSubview(newView)
      newView <- Edges()
      view.easy_reload()
      currentView?.isHidden = false
    }
  }

  override func viewDidLoad() {
    setupView()
  }

  func setupView() {
    view.backgroundColor = UIColor.white
    headerView.itemChangedHandler = { self.currentItem = $0 }
    automaticallyAdjustsScrollViewInsets = false
    extendedLayoutIncludesOpaqueBars = true

    view.addSubview(headerView)
    view.addSubview(containerView)
    view.addSubview(loaderView)

    headerView <- [
      Top(),
      Height(270),
      Left(),
      Right()
    ]

    containerView <- [
      Top().to(headerView),
      Left(),
      Right(),
      Bottom()
    ]

    loaderView <- [
      Top().to(headerView),
      Left(),
      Right(),
      Bottom()
    ]
    currentView = itemsTableView
    loaderView.isHidden = isRefreshing

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MainTabBarController.instance.tabBarHidden = true
    RootViewController.instance?.configureMenuView(items: optionViews, handler: nil)
  }
}
