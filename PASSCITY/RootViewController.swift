//
//  RootViewController.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

private let optionItemHeight = 50

class RootViewController: UIViewController {
  private(set) static var instance: RootViewController? = nil

  let mainTabBarController = MainTabBarController()
  let updateAppViewController = UpdateAppViewController()
  let cardChoiceViewController = CardChoiceViewController()
  let maskView = UIView()
  let menuView = UIStackView()

  private var currentViewController: UIViewController? = nil {
    didSet {
      oldValue?.removeFromParentViewController()
      oldValue?.view.removeFromSuperview()
      maskView.removeFromSuperview()
      guard let currentViewController = currentViewController else { return }
      self.addChildViewController(currentViewController)
      currentViewController.view.frame = self.view.frame
      self.view.addSubview(currentViewController.view)
      currentViewController.didMove(toParentViewController: self)
      self.view.addSubview(maskView)
      maskView <- Edges()
    }
  }

  var menuVisible: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let `self` = self else { return }
        if self.menuVisible {
          self.maskView.isUserInteractionEnabled = true
          self.menuView <- [
            Bottom()
          ]
          self.maskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        } else {
          self.maskView.isUserInteractionEnabled = false
          self.menuView <- [
            Bottom(-self.menuView.frame.height)
          ]
          self.maskView.backgroundColor = UIColor.clear
        }
        self.view.layoutIfNeeded()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if ProfileService.instance.isAuthorized {
      ProfileService.instance.getSettings(completion: { _ in })
      setTabBar()
    } else {
      setRegistration()
    }
    menuView.backgroundColor = UIColor.white
    menuView.axis = .vertical
    menuView.distribution = .fillEqually
    menuView.spacing = 0

    maskView.backgroundColor = UIColor.clear
    maskView.isUserInteractionEnabled = false

    maskView.isUserInteractionEnabled = false
    maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maskViewAction)))
  }

  func maskViewAction() {
    menuVisible = false
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

  func configureMenuView(items: [MenuOptionItemView], handler: ((Int) -> Void)? = nil) {
    menuView.removeFromSuperview()
    view.addSubview(menuView)
    let height = CGFloat(items.count * optionItemHeight)
    menuView.arrangedSubviews.forEach { [weak self] subview in
      self?.menuView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }

    items.enumerated().forEach { (index, item) in
      menuView.addArrangedSubview(item)
      item.handler = { [weak self] _ in
        self?.menuVisible = false
        handler?(index)
      }
    }

    menuView <- [
      Height(height),
      Bottom(-height),
      Left(),
      Right()
    ]
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return currentViewController?.preferredStatusBarStyle ?? .default
  }

  override func loadView() {
    RootViewController.instance = self
    super.loadView()
  }
  
}
