//
//  CardViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardViewController: UIViewController, TransparentViewController, LightContentViewController  {
  let headerView = CardHeaderView.nibInstance()!
  let contentView = UIScrollView()
  let contentContainerView = UIView()

  let footerView = CardFooterView()

  let ownerView = CardUserView()
  let bonusView = CardBonusView()
  let promoCodeView = CardPromoCodeView()
  let balanceView = CardBalanceView()

  let lineView = UIView()

  var currentItem: CardScreenItem = .owner {
    didSet {
      headerView.currentItem = currentItem

      guard currentItem != oldValue else { return }
      switch currentItem {
      case .owner:
        currentView = ownerView
      case .balance:
        currentView = balanceView
      case .promoCode:
        currentView = promoCodeView
      case .bonus:
        currentView = bonusView
      }
    }
  }

  var currentView: UIView? = nil {
    didSet {
      oldValue?.removeFromSuperview()

      guard let newView = currentView else { return }
      contentContainerView.addSubview(newView)
      newView <- [
        Edges(),
        Width().like(view)
      ]
      view.updateConstraints()
      view.layoutIfNeeded()
    }
  }

  var card: PassCityCard? = nil {
    didSet {
      configure()
    }
  }

  func configure() {
    guard let card = card else { return }
    headerView.configure(card: card)
    footerView.configure(card: card)
    ownerView.configure(card: card)
    bonusView.configure(card: card)
    promoCodeView.configure(card: card)
    balanceView.configure(card: card)
  }

  func refresh() {
    card = ProfileService.instance.currentCard
    ProfileService.instance.fetchCard { result in
      switch result {
      case .success(let card):
        self.card = card
      case .failure(_):
        break
      }
    }
  }

  override func viewDidLoad() {
    automaticallyAdjustsScrollViewInsets = false

    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb")))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarSettings").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsAction))
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    view.addSubview(headerView)
    view.addSubview(contentView)

    contentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    headerView <- [
      Top(),
      Height(323),
      Left(),
      Right()
    ]

    contentView <- [
      Top().to(headerView),
      Left(),
      Right(),
      Width().like(view),
      Bottom().to(bottomLayoutGuide)
    ]

    contentView.addSubview(contentContainerView)

    contentContainerView <- [
      Top(),
      Left(),
      Right(),
      Width().like(view)
    ]

    currentView = ownerView

    contentView.addSubview(lineView)
    lineView.backgroundColor = UIColor.disabledBtnColor
    lineView <- [
      Height(0.5),
      Left(),
      Right(),
      Top().to(contentContainerView)
    ]

    contentView.addSubview(footerView)

    footerView <- [
      Left(),
      Right(),
      Top().to(lineView),
      Bottom()
    ]

    configureHandlers()
    refresh()
  }

  func configureHandlers() {
    headerView.itemChangedHandler = { self.currentItem = $0 }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }

  func settingsAction() {
    let viewController = SettingsViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

}
