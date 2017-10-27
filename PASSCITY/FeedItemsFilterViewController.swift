//
//  FeedItemsFilterViewController.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy


private enum Sections: Int {
  case datesRange = 0
  case other

  var title: String? {
    switch self {
    case .datesRange:
      return "Фильтр по диапазону дат"
    case .other:
      return nil
    }
  }

  var image: UIImage? {
    switch self {
    case .datesRange:
      return #imageLiteral(resourceName: "iconTitleDaterange")
    default:
      return nil
    }
  }

  static let allValues = [datesRange, other]
}

class FeedItemsFilterViewController: UITableViewController {
  let notificationServiceCell = SwitchTableViewCell("Доступные услуги поблизости")
  let notificationProductCell = SwitchTableViewCell("Доступные продукты поблизости")
  var notificationCells: [UITableViewCell] { return [notificationServiceCell, notificationProductCell] }

  let distanceCell = SliderTableViewCell()

  var categories: [Category] {
    return currentSettings?.categories ?? []
  }

  var currentSettings: Settings? = nil {
    didSet {
      guard let currentSettings = currentSettings else { return }
      notificationProductCell.isOn = currentSettings.notifications.newProductsNearMe == 0
      notificationServiceCell.isOn = currentSettings.notifications.servicesNearMe == 0
      distanceCell.value = Float(currentSettings.notifications.distance) / 1000
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if currentSettings == nil {
      view.isUserInteractionEnabled = false
      ProfileService.instance.getSettings { [weak self] _ in
        self?.view.isUserInteractionEnabled = true
        self?.currentSettings = ProfileService.instance.currentSettings
      }
    }
    updateLayout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    SettingsCategoryTableViewCell.register(in: tableView)
    SettingsSelectableCell.register(in: tableView)
    SettingsTableSectionView.register(in: tableView)

    distanceCell.leftLabel.text = "100 м"
    distanceCell.middleLabel.text = "500 м"
    distanceCell.rightLabel.text = "1 км"

    navigationItem.title = "Настройки"

    notificationProductCell.handler = { [weak self] isOn in
      self?.currentSettings?.notifications.newProductsNearMe = isOn ? 1 : 0
    }

    notificationServiceCell.handler = { [weak self] isOn in
      self?.currentSettings?.notifications.servicesNearMe = isOn ? 1 : 0
    }

    distanceCell.handler =  { [weak self] distance in
      self?.currentSettings?.notifications.distance = Int(1000 * distance)
    }


    currentSettings = ProfileService.instance.currentSettings
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allValues.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Sections(rawValue: section) else { return 0 }
    switch section {
    case .datesRange:
      return 2
    case .other:
      return 4
    }
  }
/*
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
    switch section {
    case .datesRange:
      let cell = SettingsCategoryTableViewCell.instance(tableView, indexPath)!
      cell.configure(category: categories[indexPath.row])
      return cell
    case .other:
      return notificationCells[indexPath.row]
    case .language:
      let lang = Language.allValues[indexPath.row]
      let cell = SettingsSelectableCell.instance(tableView, indexPath)!
      cell.label.text = lang.name
      cell.isActive = currentSettings?.language == lang
      return cell
    case .notificationsDistance:
      return distanceCell
    }
  }
*/
  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Sections(rawValue: indexPath.section), section != .datesRange else { return UITableViewAutomaticDimension }
    return 90
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let currentSection = Sections(rawValue: section) else { return 0 }
    return 40
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let currentSection = Sections(rawValue: section) else { return nil }
    let view = SettingsTableSectionView.instance(tableView)
    //view?.configure(title: currentSection.title, description: currentSection.description, icon: currentSection.image)
    return view
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}
