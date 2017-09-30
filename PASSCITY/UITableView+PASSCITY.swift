//
//  UITableView+PASSCITY.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UITableViewCell {

  /// Default reuse identifier should be the same as object class name
  static var defaultReuseIdentifier: String {
    return String(describing: self)
  }

  private class func loadInstance<CellType: UITableViewCell>(_ tableView: UITableView, _ indexPath: IndexPath?, identifier: String? = nil) -> CellType? {
    if let indexPath = indexPath {
      return tableView.dequeueReusableCell(withIdentifier: identifier ?? defaultReuseIdentifier, for: indexPath) as? CellType
    } else {
      return tableView.dequeueReusableCell(withIdentifier: identifier ?? defaultReuseIdentifier) as? CellType
    }
  }

  class func register(in tableView: UITableView) {
    tableView.register(self, forCellReuseIdentifier: defaultReuseIdentifier)
  }

  class func instance(_ tableView: UITableView, _ indexPath: IndexPath? = nil, identifier: String? = nil) -> Self? {
    return loadInstance(tableView, indexPath, identifier: identifier)
  }
}

extension UITableView {
  //set the tableFooterView so that the required height can be determined, update the header's frame and set it again
  func setAndLayoutTableFooterView(footer: UIView) {
    self.tableFooterView = footer
    footer.easy_reload()
    footer.setNeedsLayout()
    footer.layoutIfNeeded()
    let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var frame = footer.frame
    frame.size.height = height
    footer.frame = frame
    self.tableFooterView = footer
  }

  func setAndLayoutTableHeaderView(header: UIView) {
    self.tableHeaderView = header
    header.easy_reload()
    header.setNeedsLayout()
    header.layoutIfNeeded()
    let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var frame = header.frame
    frame.size.height = height
    header.frame = frame
    self.tableHeaderView = header
  }

  func setTableHeaderView(headerView: UIView) {
    headerView.translatesAutoresizingMaskIntoConstraints = false

    self.tableHeaderView = headerView

    headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
  }

  func shouldUpdateHeaderViewFrame() -> Bool {
    guard let headerView = self.tableHeaderView else { return false }
    let oldSize = headerView.bounds.size
    headerView.layoutIfNeeded()
    let newSize = headerView.bounds.size
    return oldSize != newSize
  }

}

