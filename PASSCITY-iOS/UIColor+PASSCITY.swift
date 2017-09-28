//
//  UIColor+PASSCITY.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
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

}
