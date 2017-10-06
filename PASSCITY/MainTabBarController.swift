//
//  MainTabBarController.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
  let availableViewController = AvailableViewController()
  let cardViewController = CardViewController()
  let shopViewController = ShopViewController()
  let notificationsListViewController = NotificationsListViewController()

  var availableNavigationViewController: PassCityNavigationController!
  var cardNavigationViewController: PassCityNavigationController!
  var shopNavigationViewController: PassCityNavigationController!
  var notificationsListNavigationViewController: PassCityNavigationController!

  override func loadView() {
    super.loadView()

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

  }

}
