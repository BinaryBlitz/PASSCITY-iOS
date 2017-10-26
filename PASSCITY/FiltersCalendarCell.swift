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

  var date: Date? {
    get {
      return datePicker.date
    }
    set {
      dateLabel.text = newValue?.shortDate ?? ""
      datePicker.date = newValue ?? Date()
      iconCheck.isHidden = newValue == nil
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    isExpanded = false
    iconCheck.isHidden = true
    datePicker.setValue(UIColor.black, forKeyPath: "textColor")
    contentView.backgroundColor = UIColor.clear
    datePicker.datePickerMode = .countDownTimer
    datePicker.datePickerMode = .date
    datePicker.minimumDate = Date()
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }

  func dateChanged() {
    dateLabel.text = date?.shortDate ?? ""
  }

  var isExpanded: Bool = false {
    didSet {
      iconCheck.isHidden = !isExpanded
      datePicker.isHidden = !isExpanded
      dateLabel.textColor = isExpanded ? UIColor.black : UIColor.lowGrey
      tableView?.beginUpdates()
      tableView?.endUpdates()
    }
  }
}
