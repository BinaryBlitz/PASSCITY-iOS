//
//  RootViewController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

class RootViewController: UIViewController {
  private(set) static var instance: RootViewController? = nil

  let mainTabBarController = MainTabBarController()
  let updateAppViewController = UpdateAppViewController()
  let cardChoiceViewController = CardChoiceViewController()

  var currentViewController: UIViewController? = nil {
    didSet {
      oldValue?.removeFromParentViewController()
      oldValue?.view.removeFromSuperview()

      guard let currentViewController = currentViewController else { return }
      self.addChildViewController(currentViewController)
      currentViewController.view.frame = self.view.frame
      self.view.addSubview(currentViewController.view)
      currentViewController.didMove(toParentViewController: self)
    }
  }

  override func viewDidLoad() {
    if ServicesManager.usersService.isAuthorized {
      setTabBar()
    } else {
      setOnboarding()
    }
  }

  func setTabBar() {
    currentViewController = mainTabBarController
  }

  func setRegistration() {
    let navigationViewController = PassCityNavigationController(rootViewController: cardChoiceViewController)
    currentViewController = navigationViewController
  }

  func setAppUpdate() {
    let navigationViewController = PassCityNavigationController(rootViewController: updateAppViewController)
    currentViewController = navigationViewController
  }

  override func loadView() {
    RootViewController.instance = self
    super.loadView()
  }
  
}
