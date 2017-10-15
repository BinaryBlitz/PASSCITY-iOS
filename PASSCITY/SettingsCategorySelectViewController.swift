//
//  SettingsCategorySelectViewController.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class SettingsCategorySelectViewController: UITableViewController {
  var categories: [Category] = []
  var handler: (([Category]) -> Void)? = nil

  override func viewDidLoad() {
    SwitchTableViewCell.register(in: tableView)
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category = categories[indexPath.row]
    let cell = SwitchTableViewCell.instance(tableView, indexPath)!
    cell.isOn = category.selected > 0
    cell.handler = { [weak self] isOn in
      self?.categories[indexPath.row].selected = isOn ? 1 : 0
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func viewWillDisappear(_ animated: Bool) {
    handler?(categories)
  }
}
