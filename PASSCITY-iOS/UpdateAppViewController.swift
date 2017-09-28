//
//  UpdateAppViewController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class UpdateAppViewController: UIViewController {
  let logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
  let updateButton = GoButton(title: "ОБНОВИТЬ")
  let titleLabel = UILabel()
  let chatButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    addConstraints()
  }

  func setupView() {
    chatButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
    titleLabel.text = "Ваша версия приложения устарела!"
    titleLabel.font = .titleLightFont
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
  }

  func addConstraints() {
    view.addSubview(logoView)
    view.addSubview(titleLabel)
    view.addSubview(updateButton)
    view.addSubview(chatButton)

    logoView <- [
      Top(70),
      CenterX()
    ]

    titleLabel <- [
      Top(140).to(logoView),
      Left(30),
      Right(30)
    ]

    chatButton <- [
      Bottom(30),
      CenterX()
    ]

    updateButton <- [
      CenterX(),
      Width(200),
      Height(48)
    ]
  }
}
