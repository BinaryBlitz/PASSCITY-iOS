//
//  AddressCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class AddressCell: UITableViewCell {
  let addressesStackView = UIStackView()

  
}


class DateItemView: UIView {
  var iconView = UIImageView()
  var titleLabel = UILabel()

  init() {
    addSubview(iconView)
    addSubview(titleLabel)
  }

  required init?(coder aDecoder: NSCoder) {

  }
}
