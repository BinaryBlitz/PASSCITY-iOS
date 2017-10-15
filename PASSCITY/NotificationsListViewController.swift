//
//  NotificationsListViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class NotificationsListViewController: PassCityWebViewController {
  init() {
    super.init(URL(string: "https://passcity.ru/api/chatra/"))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
