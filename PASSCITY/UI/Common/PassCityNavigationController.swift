//
//  PassCityNavigationController.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

protocol LightContentViewController { }
protocol TransparentViewController: class { }

class PassCityNavigationController: UINavigationController, UINavigationControllerDelegate {

  var nextViewController: UIViewController? = nil

  override func loadView() {
    super.loadView()
    delegate = self
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    view.backgroundColor = .clear
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.tintColor = UIColor.white
    navigationBar.titleTextAttributes =
      [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.black]
    setNeedsStatusBarAppearanceUpdate()
  }

  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController, animated: Bool) {
    nextViewController = viewController

    let tintColor: UIColor = viewController is LightContentViewController ? .white : .black
    navigationBar.tintColor = tintColor
    navigationBar.titleTextAttributes =
      [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular), NSForegroundColorAttributeName: tintColor]

    view.backgroundColor = viewController is TransparentViewController ? .clear : .white
    navigationBar.backgroundColor = viewController is TransparentViewController ? .clear : .white
    navigationBar.isTranslucent = viewController is TransparentViewController
    navigationBar.barStyle = viewController is TransparentViewController ? UIBarStyle.blackOpaque : UIBarStyle.default
    setNeedsStatusBarAppearanceUpdate()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let viewController = nextViewController, viewController is LightContentViewController else {
      return .default
    }
    return .lightContent
  }

  override var prefersStatusBarHidden: Bool {
    return false
  }
  
}
