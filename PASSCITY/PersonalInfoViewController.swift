//
//  PersonalInfoViewController.swift
//  PASSCITY
//
//  Created by Алексей on 29.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

class PersonalInfoViewController: UIViewController {
  @IBOutlet weak var nameField: JVFloatLabeledTextField!
  @IBOutlet weak var emailField: JVFloatLabeledTextField!
  @IBOutlet weak var phoneNumberField: JVFloatLabeledTextField!
  @IBOutlet weak var confirmButton: GoButton!
  @IBOutlet weak var chatButton: UIButton!
  @IBOutlet weak var descriptionLabel: UILabel!

  @IBOutlet weak var nameFieldCheckView: UIImageView!
  @IBOutlet weak var emailFieldCheckView: UIImageView!
  @IBOutlet weak var phoneNumberCheckView: UIImageView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  @IBAction func confirmButtonAction(_ sender: Any) {
    confirmButton.isEnabled = false
    chatButton.isEnabled = false
    view.endEditing(true)

    ProfileService.instance.auth(name: nameField.text, email: emailField.text, phone: phoneNumberField.text?.onlyDigits) { [weak self] result in
      self?.confirmButton.isEnabled = true
      self?.chatButton.isEnabled = true

      switch result {
      case .success:
        LocationService.instance.beginMonitoring()
        NotificationService.instance.configure()
        let viewController = CodeConfirmViewController.storyboardInstance()!
        self?.navigationController?.pushViewController(viewController, animated: true)
      case .failure(let error):
        self?.presentErrorAlert(message: error.localizedDescription)
      }
    }

  }

  @IBAction func skipButtonAction(_ sender: Any) {
    let viewController = PassCityWebViewController(Constants.passCitySkipUrl)
    present(PassCityNavigationController(rootViewController: viewController), animated: true)
  }

  @IBAction func textFieldEditingChanged(_ sender: Any) {
    validateForm()
  }

  var observers: [Any] = []
  var maskedPhoneInput = MaskedInput(formattingType: .phoneNumber)

  var nameIsValid: Bool {
    guard let text = nameField.text, text.characters.count > 3 else {
      return false
    }
    return true
  }

  var emailIsValid: Bool {
    guard let text = emailField.text, !text.isEmpty else {
      return false
    }
    return NSPredicate(format: "SELF MATCHES %@", Constants.emailRegexp).evaluate(with: text)
  }

  var phoneIsValid: Bool {
    return maskedPhoneInput.isValid
  }

  func validateForm() {
    let nameValid = self.nameIsValid
    let emailValid = self.emailIsValid
    let phoneValid = self.phoneIsValid

    nameFieldCheckView.isHidden = !nameValid
    emailFieldCheckView.isHidden = !emailValid
    phoneNumberCheckView.isHidden = !phoneValid

    confirmButton.isEnabled = nameValid && emailValid && phoneValid
  }

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))

    maskedPhoneInput.configure(textField: phoneNumberField)
    maskedPhoneInput.isValidHandler = { [weak self] _ in
      self?.validateForm()
    }
    maskedPhoneInput.returnHandler = { self.view.endEditing(true) }

    let currentUser = ProfileService.instance.currentLoginData
    nameField.text = currentUser.name
    emailField.text = currentUser.email
    if let phone = currentUser.phone?.onlyDigits, !phone.isEmpty {
      phoneNumberField.text = "+\(phone)"
      maskedPhoneInput.textFieldDidChange()
    }

    validateForm()
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

extension PersonalInfoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == nameField {
      emailField.becomeFirstResponder()
    } else if textField == emailField {
      phoneNumberField.becomeFirstResponder()
    }
    return true
  }
}
