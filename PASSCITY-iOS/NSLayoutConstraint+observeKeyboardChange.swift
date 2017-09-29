//
//  NSLayoutConstraint+observeKeyboardChange.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {

  func addObserversUpdateWithKeyboard(view: UIView, offset: Double? = nil, defaultConstant: CGFloat? = nil) -> [Any] {
    let currentConstant = defaultConstant ?? self.constant

    var observers: [Any] = []

    let didShowObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { [weak self] notification in
      var newValue: CGFloat? = nil
      if let offset = offset {
        newValue = CGFloat(offset)
      }
      else if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        newValue = keyboardSize.height
      }
      guard let newOffset = newValue else { return }
      
      UIView.animate(withDuration: 0.4, animations: {
        self?.constant = currentConstant + newOffset
        view.layoutIfNeeded()
      }, completion: { _ in
        view.updateConstraints()
        view.layoutIfNeeded()
      })
    })

    observers.append(didShowObserver)

    let willHideObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { [weak self] notification in
      UIView.animate(withDuration: 0.4, animations: {
        self?.constant = currentConstant
        view.layoutIfNeeded()
      }, completion: { _ in
        view.updateConstraints()
        view.layoutIfNeeded()
      })
    })

    observers.append(willHideObserver)

    return observers
  }
}
