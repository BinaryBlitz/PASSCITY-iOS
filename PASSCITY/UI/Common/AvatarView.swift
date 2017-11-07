//
//  AvatarView.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
//
//  AvatarView.swift
//  Fitmost
//
//  Created by Алексей on 06.08.17.
//  Copyright © 2017 FitmostTest. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

private let avatarColors: [UIColor] = [
  UIColor(red: 212.0 / 255.0, green: 239.0 / 255.0, blue: 223.0 / 237.0, alpha: 1.0),
  UIColor(red: 214.0 / 255.0, green: 239.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0),
  UIColor(red: 38.0 / 255.0, green: 53.0 / 255.0, blue: 173.0 / 255.0, alpha: 0.2),
  UIColor(red: 173.0 / 255.0, green: 38.0 / 255.0, blue: 103.0 / 255.0, alpha: 0.2),
  UIColor(red: 38.0 / 255.0, green: 121.0 / 255.0, blue: 173.0 / 255.0, alpha: 0.2),
  UIColor(red: 128.0 / 255.0, green: 38.0 / 255.0, blue: 173.0 / 255.0, alpha: 0.2),
  UIColor(red: 173.0 / 255.0, green: 149.0 / 255.0, blue: 38.0 / 255.0, alpha: 0.2),
  UIColor(red: 173.0 / 255.0, green: 38.0 / 255.0, blue: 38.0 / 255.0, alpha: 0.2),
]

@IBDesignable class AvatarView: UIView {
  let userImageView = UIImageView()
  let nameLabel = UILabel()

  @IBInspectable var fontSize: CGFloat = 20 {
    didSet {
      updateFontSize()
    }
  }

  func updateFontSize() {
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
  }

  func setBgColor(character: Character?) {
    let number = Int(character?.asciiValue ?? 0)
    let index = number % avatarColors.count
    backgroundColor = avatarColors[index]
  }

  func setDefaultAvatar() {
    nameLabel.isHidden = true
    userImageView.isHidden = true
    userImageView.contentMode = .center
  }

  init(user: String) {
    super.init(frame: CGRect.null)
    setup()
    configure(user: user)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  private func setup() {
    addSubview(userImageView)
    addSubview(nameLabel)

    userImageView <- [
      Edges()
    ]

    nameLabel <- [
      Edges()
    ]
    updateFontSize()
    nameLabel.textColor = UIColor.white
    nameLabel.textAlignment = .center
    userImageView.contentMode = .scaleAspectFill
    userImageView.clipsToBounds = true
  }

  func configure(imageUrl: URL? = nil, user: String? = nil) {
    if let url = imageUrl {
      nameLabel.isHidden = true
      userImageView.isHidden = false
      userImageView.kf.setImage(with: url)
      backgroundColor = UIColor.clear
    } else {
      var nameText = ""
      let firstNameChar = user?.characters.first
      let surnameChar = user?.components(separatedBy: " ").last?.characters.first

      if let firstNameChar = firstNameChar {
        nameText += "\(firstNameChar)".uppercased()
      }
      if let surnameChar = surnameChar {
        nameText += "\(surnameChar)".uppercased()
      }
      updateFontSize()
      setBgColor(character: firstNameChar ?? surnameChar)
      userImageView.isHidden = true
      nameLabel.isHidden = false
      nameLabel.text = nameText
    }
    easy_reload()
    layoutIfNeeded()

  }

  override func awakeFromNib() {
    super.awakeFromNib()
    updateFontSize()
    easy_reload()
    layoutIfNeeded()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    cornerRadius = self.frame.width / 2
    layoutIfNeeded()
  }

}

extension Character {
  var asciiValue: UInt32? {
    return String(self).unicodeScalars.first?.value
  }
}
