//
//  PassCityNavigationController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

protocol LightContentViewController { }

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

    view.backgroundColor = .white

    setNeedsStatusBarAppearanceUpdate()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let viewController = nextViewController, viewController is LightContentViewController else {
      return .default
    }
    return .lightContent
  }
  
}
