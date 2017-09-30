//
//  BaseView.swift
//  PASSCITY
//
//  Created by Алексей on 30.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

/// A base view controller protocol. Contains some helper methods
protocol BaseView: class {
  var title: String? { get set }
  func presentAlert(title: String?, message: String, handler: ((UIAlertAction) -> Void)?)
  func presentErrorAlert(message: String)
  func dismiss(animated: Bool, completion: (() -> Void)?)
  func popFromNavigationController(animated: Bool)
  func popToRootViewController(animated: Bool)
  func present(_ viewController: UIViewController, animated: Bool)
  func pushViewController(newViewController: UIViewController)
}

extension UIViewController: BaseView {

  func presentAlert(title: String?, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default, handler: handler)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func presentErrorAlert(message: String) {
    let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func popFromNavigationController(animated: Bool = true) {
    let navigationVC = navigationController ?? self as? UINavigationController
    navigationVC?.popViewController(animated: true)
  }

  func popToRootViewController(animated: Bool) {
    let navigationVC = navigationController ?? self as? UINavigationController
    navigationVC?.popToRootViewController(animated: true)
  }

  func pushViewController(newViewController: UIViewController) {
    let navigationVC = navigationController ?? self as? UINavigationController
    navigationVC?.pushViewController(newViewController, animated: true)
  }


  func present(_ viewController: UIViewController, animated: Bool = true) {
    present(viewController, animated: animated, completion: nil)
  }
}
