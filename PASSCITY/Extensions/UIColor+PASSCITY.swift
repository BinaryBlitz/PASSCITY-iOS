//
//  UIColor+PASSCITY.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  func lighter(percentage: CGFloat = 0.1) -> UIColor {
    return self.colorWithBrightness(factor: 1 + abs(percentage))
  }

  func darker(percentage: CGFloat = 0.1) -> UIColor {
    return self.colorWithBrightness(factor: 1 - abs(percentage))
  }

  func colorWithBrightness(factor: CGFloat) -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
    } else {
      return self
    }
  }

  class var backgroundGrey: UIColor {
    return UIColor(white: 216.0 / 255.0, alpha: 1.0)
  }

  class var disabledBtnColor: UIColor {
    return UIColor(white: 214.0 / 255.0, alpha: 1.0)
  }

  class var warmGrey: UIColor {
    return UIColor(white: 153.0 / 255.0, alpha: 1.0)
  }

  class var seafoamBlue: UIColor {
    return UIColor(red: 80.0 / 255.0, green: 195.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)
  }

  class var lowGrey: UIColor {
    return UIColor(red: 214.0 / 255.0, green: 214.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
  }

  class var frogGreen: UIColor {
    return UIColor(red: 114.0 / 255.0, green: 184.0 / 255.0, blue: 9.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var white20: UIColor {
    return UIColor(white: 214.0 / 255.0, alpha: 0.2)
  }
}
