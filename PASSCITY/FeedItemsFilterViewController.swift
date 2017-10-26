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
  let beginningDateCell =  FiltersCalendarCell.nibInstance()!
  let endDateCell =  FiltersCalendarCell.nibInstance()!
  let rightNowCell = UITableViewCell()

  var datesCells: [UITableViewCell] {
    return [rightNowCell, beginningDateCell, endDateCell]
  }

  let categoriesCell = SettingsCategoryTableViewCell()
  let locationCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let favoritesCell = SwitchTableViewCell("Избранное", description: "Показывать только избранное", image: #imageLiteral(resourceName: "iconFilterFavorites"))
  let hotOffersCell = SwitchTableViewCell("Горячие предложения", description: "Показывать только горячие предложения", image: #imageLiteral(resourceName: "iconFilterSentence"))

  var rightNowSelected: Bool = true {
    didSet {
      rightNowCell.textLabel?.textColor = rightNowSelected ? UIColor.black : UIColor.lowGrey
      rightNowCell.accessoryType = rightNowSelected ? .checkmark : .none
    }
  }

  var filters: PassCityFeedItemFilter? = nil {
    didSet {
      guard let filters = filters else { return }
      categoriesCell.badgeLabel.text = "\(filters.categories.count)"
      categoriesCell.badgeView.isHidden = filters.categories.isEmpty
      beginningDateCell.date = filters.dates?.from
      endDateCell.date = filters.dates?.to
      favoritesCell.isOn = filters.favorites == 1
      hotOffersCell.isOn = filters.favorites == 1
    }
  }

  var otherCells: [UITableViewCell] {
    return [categoriesCell, locationCell, favoritesCell, hotOffersCell]
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateLayout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    tableView.tableFooterView = UIView()
    configureCells()
    navigationItem.title = "Настройки"
  }

  func configureCells() {
    rightNowCell.textLabel?.text = "Прямо сейчас"
    rightNowCell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    rightNowCell.tintColor = UIColor.red
    rightNowCell.textLabel?.textColor = UIColor.black
    rightNowCell.accessoryType = .checkmark

    locationCell.textLabel?.text = "Локация"
    locationCell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    locationCell.tintColor = UIColor.red
    locationCell.textLabel?.textColor = UIColor.black
    locationCell.accessoryType = .disclosureIndicator
    locationCell.detailTextLabel?.text = "Поблизости"
    locationCell.imageView?.image = #imageLiteral(resourceName: "iconFilterMap")

    beginningDateCell.tableView = tableView
    endDateCell.tableView = tableView
    endDateCell.titleLabel.text = "Конец"

    SettingsCategoryTableViewCell.register(in: tableView)
    FiltersCalendarCell.register(in: tableView)
    SwitchTableViewCell.register(in: tableView)
    SettingsTableSectionView.register(in: tableView)

    datesCells.forEach { $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) }
    otherCells.forEach { $0.separatorInset = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0) }

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allValues.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Sections(rawValue: section) else { return 0 }
    switch section {
    case .datesRange:
      return 3
    case .other:
      return otherCells.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
    switch section {
    case .datesRange:
      return datesCells[indexPath.row]
    case .other:
      return otherCells[indexPath.row]
    }
  }

  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Sections(rawValue: indexPath.section), section == .datesRange else {
      return 44
    }
    switch indexPath.row {
    case datesCells.index(of: beginningDateCell)! where beginningDateCell.isExpanded:
      return 340
    case datesCells.index(of: endDateCell)! where endDateCell.isExpanded:
      return 340
    default:
      return 44
    }
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let currentSection = Sections(rawValue: section) else { return 0 }
    return 30
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let currentSection = Sections(rawValue: section) else { return nil }
    let view = SettingsTableSectionView.instance(tableView)
    view?.backgroundColor = UIColor.white
    switch currentSection {
    case .datesRange:
      view?.configure(title: "Фильтр по диапазону дат", description: nil, icon: #imageLiteral(resourceName: "iconTitleDaterange"))
    default:
      break
    }
    return view
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let currentSection = Sections(rawValue: indexPath.section) else { return }
    switch currentSection {
    case .datesRange:
      switch indexPath.row {
      case datesCells.index(of: rightNowCell)!:
        rightNowSelected = !rightNowSelected
      case datesCells.index(of: beginningDateCell)!:
        beginningDateCell.isExpanded = !beginningDateCell.isExpanded
      case datesCells.index(of: endDateCell)!:
        endDateCell.isExpanded = !endDateCell.isExpanded
      default:
        break
      }
    case .other:
      switch indexPath.row {
      case otherCells.index(of: categoriesCell)!:
        let viewController = FiltersCategoriesViewController()
        viewController.handler = { [weak self] categories in
          self?.filters?.categories = categories
        }
      case otherCells.index(of: locationCell):
        
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}
