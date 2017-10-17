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
  var query: [String: String] {
    return [
      "lang": ProfileService.instance.currentSettings?.language?.rawValue ?? "en",
      "hostId": "tiETi3intKLqN7Psn",
      "mode": "widget",
      "chat": "no"
    ]
  }

  init() {
    super.init(URL(string: "https://chat.chatra.io/")?.appendingQueryParams(parameters: query))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
