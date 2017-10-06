//
//  ShopViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class ShopViewController: PassCityWebViewController {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if url == nil {
      url = ProfileService.instance.currentSettings?.shopUrl
    }
  }

  init() {
    super.init(url: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
