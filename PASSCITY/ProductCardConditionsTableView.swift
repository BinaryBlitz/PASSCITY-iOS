//
//  ProductCardConditionsTableView.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

private let headerReuseIdentifier = "ProductCardTableSectionHeaderView"

class ProductCardConditionsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  var items: [Category] = [] {
    didSet {
      self.hiddenSections = Set<Int>()
      reloadData()
    }
  }

  var hiddenSections = Set<Int>()

  init() {
    super.init(frame: CGRect.null, style: .plain)
    delegate = self
    dataSource = self
    register(ProductCardConditionsTableViewCell.self, forCellReuseIdentifier: ProductCardConditionsTableViewCell.defaultReuseIdentifier)
    register(ProductCardTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
    self.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hiddenSections.contains(section) ? 0 : items[section].objects.count

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ProductCardConditionsTableViewCell.instance(self, indexPath)!
    cell.configure(items[indexPath.section].conditions[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! ProductCardTableSectionHeaderView
    view.configure(category: items[section].fullObject ?? items[section])
    view.isActive = !hiddenSections.contains(section)
    view.handler = { [weak self] in
      guard let `self` = self else { return }

      if self.hiddenSections.contains(section) {
        self.hiddenSections.remove(section)
      } else {
        self.hiddenSections.insert(section)
      }
      self.reloadData()
    }
    return view
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    return view
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 70
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

  }

}

