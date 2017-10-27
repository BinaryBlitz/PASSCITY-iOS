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

class SettingsViewController: UITableViewController {
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
    tableView.tableFooterView = footerView

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

    footerView.buttonHandler = {
      ProfileService.instance.logout()
    }

    currentSettings = ProfileService.instance.currentSettings
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allValues.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Sections(rawValue: section) else { return 0 }
    switch section {
    case .categories:
      return categories.count
    case .notifications:
      return notificationCells.count
    case .language:
      return Language.allValues.count
    case .notificationsDistance:
      return 1
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
    switch section {
    case .categories:
      let cell = SettingsCategoryTableViewCell.instance(tableView, indexPath)!
      cell.configure(category: categories[indexPath.row])
      return cell
    case .notifications:
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

  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Sections(rawValue: indexPath.section), section == .notificationsDistance else { return 44 }
    return 90
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let currentSection = Sections(rawValue: section) else { return 0 }
    return currentSection.title == nil || currentSection.description == nil ? 40 : 60
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let currentSection = Sections(rawValue: section) else { return nil }
    let view = SettingsTableSectionView.instance(tableView)
    view?.configure(title: currentSection.title, description: currentSection.description, icon: currentSection.image)
    return view
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let section = Sections(rawValue: indexPath.section) else { return }
    switch section {
    case .categories:
      let category = categories[indexPath.row]
      let viewController = SettingsCategorySelectViewController()
      viewController.title = category.title
      viewController.categories = category.children
      viewController.handler = { [weak self] categories in
        self?.currentSettings?.categories[indexPath.row].children = categories
        self?.currentSettings?.categories[indexPath.row].selected = categories.filter { $0.selected > 0 }.count
        self?.tableView.reloadData()
      }
      navigationController?.pushViewController(viewController, animated: true)
    case .language:
      currentSettings?.language = Language.allValues[indexPath.row]
      tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    default:
      break
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    updateSettings()
  }

  func updateSettings() {
    guard let settings = currentSettings else { return }
    ProfileService.instance.updateSettings(settings) { [weak self] result in
      switch result {
      case .success:
        break
      case .failure(_):
        self?.currentSettings = ProfileService.instance.currentSettings
      }
    }
  }
}
