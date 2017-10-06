//
//  PasscityWebViewController.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import EasyPeasy

class PassCityWebViewController: UIViewController {
  let webView = WKWebView()

  var url: URL? {
    didSet {
      guard let url = url else { return }
      webView.load(URLRequest(url: url))
    }
  }

  init(url: URL?) {
    super.init(nibName: nil, bundle: nil)
    view = webView
    self.url = url
    guard let url = url else { return }
    webView.load(URLRequest(url: url))
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    view = webView
  }

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))

    if let navigationController = navigationController, navigationController.viewControllers.count == 1 {
      navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarClose"), style: .plain, target: self, action: #selector(closeButtonAction))
    }
  }

  func closeButtonAction() {
    dismiss(animated: true, completion: nil)
  }
}
