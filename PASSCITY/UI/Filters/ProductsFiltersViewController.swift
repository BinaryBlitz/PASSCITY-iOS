//
//  ProductsFiltersViewController.swift
//  PASSCITY
//
//  Created by Алексей on 30.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProductsFiltersViewController: UITableViewController {

  let categoriesCell = SettingsCategoryTableViewCell()
  let packagesCell = SwitchTableViewCell("Пакеты услуг", image: #imageLiteral(resourceName: "iconFilterPac"))
  let ticketsCell = SwitchTableViewCell("Билеты", image: #imageLiteral(resourceName: "iconFilterSentence"))
  let hotOffersCell = SwitchTableViewCell("Горячие предложения", image: #imageLiteral(resourceName: "iconFilterTicket"))
  let expiredCell = SwitchTableViewCell("С истекшим сроком", image: #imageLiteral(resourceName: "iconFilterDaterange"))

  var cells: [UITableViewCell] {
    return [categoriesCell, packagesCell, ticketsCell, hotOffersCell, expiredCell]
  }

  var handler: ((ProductsFilter) -> Void)? = nil

  var filters: ProductsFilter? = nil {
    didSet {
      guard let filters = filters else { return }
      categoriesCell.badgeLabel.text = "\(filters.categories.count)"
      categoriesCell.badgeView.isHidden = filters.categories.isEmpty
      packagesCell.isOn = filters.packages == 1
      ticketsCell.isOn = filters.services == 1
      hotOffersCell.isOn = filters.hotOffers == 1
      expiredCell.isOn = filters.expired == 1
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureCells()
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    tableView.tableFooterView = UIView()
    configureCells()
    navigationItem.title = "Фильтр"

  }
  func configureCells() {
    packagesCell.handler = { [weak self] isOn in
      self?.filters?.packages = isOn ? 1 : 0
    }

    hotOffersCell.handler = { [weak self] isOn in
      self?.filters?.hotOffers = isOn ? 1 : 0
    }

    expiredCell.handler = { [weak self] isOn in
      self?.filters?.expired = isOn ? 1 : 0
    }

    ticketsCell.handler = { [weak self] isOn in
      self?.filters?.services = isOn ? 1 : 0
    }

    categoriesCell.titleLabel.text = "Категории"
    categoriesCell.iconView.image = #imageLiteral(resourceName: "iconFilterCategories")
    categoriesCell.iconView <- Size(20)
    categoriesCell.circleView <- Size(23)

    SettingsCategoryTableViewCell.register(in: tableView)
    SwitchTableViewCell.register(in: tableView)
    SettingsTableSectionView.register(in: tableView)

    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cells[indexPath.row]
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case cells.index(of: categoriesCell)!:
      let viewController = FiltersCategoriesViewController()
      viewController.handler = { [weak self] categories in
        self?.filters?.categories = categories
      }
      self.navigationController?.pushViewController(viewController, animated: true)
    default:
      break
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard var filters = filters else { return }
    handler?(filters)
  }


}
