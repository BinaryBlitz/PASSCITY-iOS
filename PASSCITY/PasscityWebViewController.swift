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

  init(_ url: URL? = nil) {
    super.init(nibName: nil, bundle: nil)
    self.url = url
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))

    if let navigationController = navigationController, navigationController.viewControllers.count == 1 {
      navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavbarClose"), style: .plain, target: self, action: #selector(closeButtonAction))
    }
    webView.navigationDelegate = self
    setupView()
    guard let url = url else { return }
    webView.load(URLRequest(url: url))
  }

  func setupView() {
    view.addSubview(webView)
    webView <- [
      Top().to(topLayoutGuide),
      Bottom().to(bottomLayoutGuide),
      Left(),
      Right()
    ]
  }

  func closeButtonAction() {
    dismiss(animated: true, completion: nil)
  }
}

extension PassCityWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    NetworkActivityIndicator.sharedIndicator.visible = true
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    NetworkActivityIndicator.sharedIndicator.visible = false
  }
}
