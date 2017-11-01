//
//  FiltersCategoriesListViewController.swift
//  PASSCITY
//
//  Created by Алексей on 30.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class FiltersCategoriesViewController: UITableViewController {
  var categories: [Category] {
    return ProfileService.instance.currentSettings?.categories ?? []
  }

  var handler: (([Int]) -> Void)? = nil
  var selectedCategories = Set<Int>() {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    handler?(Array(selectedCategories))
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    SettingsCategoryTableViewCell.register(in: tableView)
    title = "Категории"
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = SettingsCategoryTableViewCell.instance(tableView, indexPath)!
    let category = categories[indexPath.row]
    let selectedChildren = category.children
      .map { $0.id }
      .filter { self.selectedCategories.contains($0) }
    cell.configure(category: categories[indexPath.row], selectedCategories: selectedChildren)
    return cell
  }

  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let category = categories[indexPath.row]
    let viewController = SettingsCategorySelectViewController()
    viewController.title = category.title
    viewController.categories = category.children
    viewController.handler = { [weak self] categories in
      for child in category.children {
        self?.selectedCategories.remove(child.id)
      }
      self?.selectedCategories.formUnion(categories.map { $0.id })
      self?.tableView.reloadData()
    }
    self.navigationController?.pushViewController(viewController, animated: true)
  }

}
