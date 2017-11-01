//
//  MainTabBarController.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class MainTabBarController: UITabBarController {
  let availableViewController = AvailableViewController()
  let cardViewController = CardViewController()
  let shopViewController = ShopViewController()
  let notificationsListViewController = NotificationsListViewController()

  var availableNavigationViewController: PassCityNavigationController!
  var cardNavigationViewController: PassCityNavigationController!
  var shopNavigationViewController: PassCityNavigationController!
  var notificationsListNavigationViewController: PassCityNavigationController!

  var playerHeightConstraint: NSLayoutConstraint!

  static var instance: MainTabBarController!

  let playerView = PlayerWidgetView.nibInstance()!

  var playerWidgetHeight: CGFloat {
    return playerHeightConstraint.constant
  }

  var playerIsHidden: Bool = true {
    didSet {
      playerHeightConstraint.constant = playerIsHidden ? 0 : 58
      playerView.isHidden = playerIsHidden
      NotificationCenter.default.post(name: .playerHeightChanged, object: nil)
    }
  }

  var tabBarHidden: Bool {
    get {
      return tabBar.isHidden
    }
    set {
      tabBar.isHidden = newValue
      playerView <- [
        Bottom(newValue ? 0 : tabBar.frame.height),
        Left(),
        Right()
      ]
    }
  }

  override func loadView() {
    super.loadView()

    MainTabBarController.instance = self

    availableNavigationViewController = PassCityNavigationController(rootViewController: availableViewController)
    availableNavigationViewController.tabBarItem = UITabBarItem(title: "Доступно", image: #imageLiteral(resourceName: "iconTabbarAvailable"), tag: 0)

    cardNavigationViewController = PassCityNavigationController(rootViewController: cardViewController)
    cardNavigationViewController.tabBarItem = UITabBarItem(title: "Карта", image: #imageLiteral(resourceName: "iconTabbarCard"), tag: 1)

    notificationsListNavigationViewController = PassCityNavigationController(rootViewController: notificationsListViewController)
    notificationsListViewController.tabBarItem = UITabBarItem(title: "Оповещения", image: #imageLiteral(resourceName: "iconTabbarChat"), tag: 2)

    shopNavigationViewController = PassCityNavigationController(rootViewController: shopViewController)
    shopNavigationViewController.tabBarItem = UITabBarItem(title: "Магазин", image: #imageLiteral(resourceName: "iconTabbarShop"), tag: 3)

    tabBar.tintColor = UIColor.red
    tabBar.unselectedItemTintColor = UIColor.black
    setViewControllers([availableNavigationViewController, cardNavigationViewController, notificationsListNavigationViewController, shopNavigationViewController], animated: false)

    view.addSubview(playerView)

    playerView <- [
      Bottom(tabBar.frame.height),
      Left(),
      Right()
    ]
    playerView.isHidden = true
    playerHeightConstraint = playerView.heightAnchor.constraint(equalToConstant: 0)
    playerHeightConstraint.isActive = true
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return selectedViewController?.preferredStatusBarStyle ?? .default
  }

}
