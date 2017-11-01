//
//  UIView+nibInstance.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  internal class func getNibInstance<T:UIView>() -> T? {
    return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T

  }

  class func nibInstance() -> Self? {
    return getNibInstance()
  }
}
