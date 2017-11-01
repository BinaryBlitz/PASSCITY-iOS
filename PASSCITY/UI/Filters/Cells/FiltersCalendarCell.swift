//
//  FiltersCalendarCell.swift
//  PASSCITY
//
//  Created by Алексей on 27.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

protocol ExpandableCell { }

class FiltersCalendarCell: UITableViewCell, ExpandableCell {
  @IBOutlet weak var iconCheck: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var titleLabel: UILabel!

  var tableView: UITableView? = nil

  var dateChangedHandler: ((Date?) -> Void)? = nil

  var date: Date? = nil {
    didSet {
      dateLabel.text = "\(date?.shortDate ?? "") \(date?.time ?? "")"
      datePicker.date = date ?? Date()
      iconCheck.isHidden = date == nil
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    isExpanded = false
    iconCheck.isHidden = true
    datePicker.setValue(UIColor.black, forKeyPath: "textColor")
    contentView.backgroundColor = UIColor.clear
    datePicker.minimumDate = Date()
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    iconCheck.image = iconCheck.image?.withRenderingMode(.alwaysTemplate)
  }

  func dateChanged() {
    dateLabel.text = "\(date?.shortDate ?? "") \(date?.time ?? "")"
    date = datePicker.date
    dateChangedHandler?(date)
  }

  var isExpanded: Bool = false {
    didSet {
      datePicker.isHidden = !isExpanded
      dateLabel.textColor = isExpanded ? UIColor.black : UIColor.lowGrey
      if isExpanded {
        date = datePicker.date
        dateChangedHandler?(date)
      }
      tableView?.beginUpdates()
      tableView?.endUpdates()
    }
  }
}
