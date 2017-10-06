//
//  CodeConfirmViewController.swift
//  PASSCITY
//
//  Created by Алексей on 30.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

class CodeConfirmViewController: UIViewController {
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var codeField: UITextField!
  @IBOutlet weak var confirmButton: GoButton!
  @IBOutlet weak var iconDoneImageView: UIImageView!
  @IBOutlet weak var sendAgainButton: UIButton!

  var observers: [Any] = []

  @IBAction func confirmButtonAction(_ sender: Any) {
    guard let code = codeField.text?.onlyDigits, !code.isEmpty else { return }
    confirmButton.isEnabled = false
    codeField.isEnabled = false

    ProfileService.instance.checkCode(code: code) { [weak self] result in
      self?.confirmButton.isEnabled = true
      self?.codeField.isEnabled = true

      switch result {
      case .success:
        let currentProfile = ProfileService.instance.currentLoginData
        if currentProfile.client != 1 {
          let viewController = PassCityWebViewController(url: Constants.passCitySkipUrl)
          self?.present(PassCityNavigationController(rootViewController: viewController), animated: true)
        } else {
          RootViewController.instance?.setTabBar()
        }
      case .failure(let error):
        self?.presentErrorAlert(message: error.localizedDescription)
      }
    }
  }

  func resetButton() {
    sendAgainButton.isEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 60.0, execute: { [weak self] in
      self?.sendAgainButton.isEnabled = true
    })
  }
  
  @IBAction func sendAgainButtonAction(_ sender: Any) {
    codeField.text = ""
    sendAgainButton.isEnabled = false
    confirmButton.isEnabled = false

    ProfileService.instance.auth() { [weak self] result in
      self?.resetButton()

      switch result {
      case .success:
        self?.presentAlert(title: nil, message: "Код был отправлен еще раз на Ваш номер телефона")
      case .failure(let error):
        self?.presentErrorAlert(message: error.localizedDescription)
      }
    }
  }

  var isValid: Bool = true {
    didSet {
      let isValid = self.isValid
      UIView.animate(withDuration: 0.2) { [weak self] in
        self?.confirmButton.isEnabled = isValid
        self?.iconDoneImageView.alpha = isValid ? 1 : 0
        self?.view.layoutIfNeeded()
      }
    }
  }

  let barCodeMaskedInput = MaskedInput(formattingType: .pattern("* * * * *"))

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))
    isValid = false
    barCodeMaskedInput.configure(textField: codeField)
    barCodeMaskedInput.returnHandler = { self.view.endEditing(true) }
    barCodeMaskedInput.isValidHandler = { self.isValid = $0 }

    resetButton()
    hideKeyboardWhenTappedAround()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.observers = bottomLayoutConstraint.addObserversUpdateWithKeyboard(view: view)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    self.observers.forEach { NotificationCenter.default.removeObserver($0) }
    self.observers = []
  }
}
