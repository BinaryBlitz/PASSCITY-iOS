//
//  SettingsViewController.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

private enum Sections: Int {
  case categories = 0
  case notifications
  case notificationsDistance
  case language

  var title: String? {
    switch self {
    case .categories:
      return "Категории услуг"
    case .notifications:
      return "Геотаргетированные уведомления"
    case .notificationsDistance:
      return nil
    case .language:
      return "Язык сервиса / контента"
    }
  }

  var description: String? {
    switch self {
    case .notificationsDistance:
      return "Уведомлять об объектах, находящихся от меня на расcтоянии"
    default:
      return nil
    }
  }

  var image: UIImage? {
    switch self {
    case .categories:
      return #imageLiteral(resourceName: "iconTitleCategories")
    case .notifications:
      return #imageLiteral(resourceName: "iconTitleNotice")
    case .notificationsDistance:
      return nil
    case .language:
      return #imageLiteral(resourceName: "iconTitleLanguage")
    }
  }

  static let allValues = [categories, notifications, notificationsDistance, language]
}

class SettingsViewController: UITableViewController {
  let footerView = PassCityTableButtonFooterView(title: "Выйти из приложения")

  let notificationServiceCell = SwitchTableViewCell("Доступные услуги поблизости")
  let notificationProductCell = SwitchTableViewCell("Доступные продукты поблизости")
  var notificationCells: [UITableViewCell] { return [notificationServiceCell, notificationProductCell] }

  let distanceCell = SliderTableViewCell()

  var categories: [Category] = []

  var currentSettings: Settings? = nil {
    didSet {
      guard let currentSettings = currentSettings else { return }
      categories = currentSettings.categories
      notificationProductCell.isOn = currentSettings.notifications.newProductsNearMe == 0
      notificationServiceCell.isOn = currentSettings.notifications.servicesNearMe == 0
      distanceCell.value = Float(currentSettings.notifications.distance)
    }
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

    navigationItem.title = "Настройки"

    notificationProductCell.handler = { [weak self] isOn in

    }

    notificationServiceCell.handler = { [weak self] isOn in

    }

    distanceCell.handler =  { [weak self] distance in

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

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Sections(rawValue: indexPath.section), section == .notificationsDistance else { return 44 }
    return 80
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
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
      break
    case .language:
      currentSettings?.language = Language.allValues[indexPath.row]
      tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    default:
      break
    }
  }
}
