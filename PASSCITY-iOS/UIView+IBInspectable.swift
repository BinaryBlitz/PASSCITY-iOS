//
//  UIView+IBInspectable.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

  @IBInspectable var shadowOpacity: CGFloat {
    get {
      return CGFloat(layer.shadowOpacity)
    }
    set {
      self.layer.shadowOpacity = Float(newValue)

    }
  }

  @IBInspectable var shadow: Bool {
    get {
      return layer.shadowOpacity > 0.0
    }
    set {
      if newValue {
        addShadow()
      }
    }
  }

  func addShadow(shadowColor: CGColor = UIColor.black8.cgColor,
                 shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                 shadowOpacity: Float = 0.2,
                 shadowRadius: CGFloat = 3.0) {
    layer.shadowColor = shadowColor
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
    layer.shadowRadius = shadowRadius
  }

  func addBlur() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.clipsToBounds = true
    blurEffectView.cornerRadius = cornerRadius
    blurEffectView.alpha = 0.9
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    insertSubview(blurEffectView, at: 0)
  }

}

extension UITextField {
  @IBInspectable var placeholderColor: UIColor? {
    get {
      return UIColor.clear
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
    }
  }
}

@IBDesignable class RotatingUIView: UIView {

  @IBInspectable var angle: Double = .pi / 4

  override func awakeFromNib() {
    super.awakeFromNib()
    self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
  }
}

@IBDesignable class GradientView: UIView {
  private var gradient : CAGradientLayer = CAGradientLayer()

  @IBInspectable var reverse: Bool = false
  @IBInspectable var vertical: Bool {
    set {
      axis = vertical ? .vertical : .horizontal
    }
    get {
      return axis == .vertical
    }
  }
  @IBInspectable var firstColor: UIColor = .black
  @IBInspectable var gradientBackgroundColor: UIColor = .clear
  @IBInspectable var axis: Axis = .vertical {
    didSet {
      reconfigureGradient()
    }
  }
  @IBInspectable var secondColor: UIColor = UIColor.black.withAlphaComponent(0)

  override func awakeFromNib() {
    reconfigureGradient()
  }

  func reconfigureGradient() {
    gradient.removeFromSuperlayer()
    self.gradient = CAGradientLayer()
    gradient.frame.size = self.frame.size

    gradient.colors = [firstColor.cgColor, secondColor.cgColor]
    if reverse { gradient.colors?.reverse() }
    if axis == .horizontal {
      gradient.startPoint = CGPoint(x: 0, y: 0.5)
      gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }
    gradient.frame.size = self.frame.size
    gradient.backgroundColor = gradientBackgroundColor.cgColor

    self.layer.insertSublayer(gradient, at: 0)
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    gradient.frame = self.bounds
  }

  init(first: UIColor = UIColor.redPinkGradientStart, second: UIColor = UIColor.tealishGradientEnd, bckColor: UIColor = .greyishPurpleBackground, axis: Axis) {
    super.init(frame: CGRect.null)
    self.firstColor = first
    self.secondColor = second
    self.axis = axis
    self.gradientBackgroundColor = bckColor
    reconfigureGradient()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    reconfigureGradient()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  enum Axis: String {
    case horizontal
    case vertical
  }
}
