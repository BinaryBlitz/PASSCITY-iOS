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

  var query: [String: String] {
    return ["lang": ProfileService.instance.currentSettings?.language?.rawValue ?? "en"]
  }

  override func viewWillAppear(_ animated: Bool) {
    if url == nil {
      url = ProfileService.instance.currentSettings?.shopUrl?.appendingQueryParams(parameters: query)
    }
  }

  override func viewDidLoad() {
    if url == nil {
      url = ProfileService.instance.currentSettings?.shopUrl?.appendingQueryParams(parameters: query)
    }
    super.viewDidLoad()
  }

  init() {
    super.init(ProfileService.instance.currentSettings?.shopUrl?.appendingQueryParams(parameters: query))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
