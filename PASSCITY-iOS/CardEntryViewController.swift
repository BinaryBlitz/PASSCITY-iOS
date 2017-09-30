//
//  CardEntryViewController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class CardEntryViewController: UIViewController {
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardNumberField: UITextField!
  @IBOutlet weak var confirmButton: GoButton!
  @IBOutlet weak var scanCodeButton: UIButton!
  @IBOutlet weak var scanCodeTextButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var retryLeftCountLabel: UILabel!
  @IBOutlet weak var iconDoneImageView: UIImageView!
  @IBOutlet var additionalViews: [UIView]!

  var observers: [Any] = []

  var leftTries = 3 {
    didSet {
      ProfileService.instance.cardInputTriesLeft = leftTries
      retryLeftCountLabel.text = "Осталось \(leftTries.getRussianNumEnding(["попытка", "попытки", "попыток"]))"
      if leftTries == 0 {
        scanCodeButton.isEnabled = false
        scanCodeTextButton.isEnabled = false
        confirmButton.isEnabled = false
        cardNumberField.isEnabled = false
        presentAlert(title: nil, message: "Доступных попыток ввода карты не осталось")
      }
    }
  }

  @IBAction func scanCodeButtonsAction(_ sender: Any) {
    let viewController = BarcodeScanViewController()
    viewController.codeDidPickHandler = { [weak self] code in
      viewController.dismiss(animated: true, completion: nil)
      self?.cardNumberField.text = code
      self?.barCodeMaskedInput.textFieldDidChange()
    }
    present(viewController, animated: true, completion: nil)
  }

  @IBAction func chatButtonAction(_ sender: Any) {

  }
  
  @IBAction func confirmButtonAction(_ sender: Any) {
    guard let cardNumber = cardNumberField.text?.onlyDigits, !cardNumber.isEmpty else { return }
    confirmButton.isEnabled = false
    cardNumberField.isEnabled = false

    ProfileService.instance.auth(barCode: cardNumber) { [weak self] result in
      self?.confirmButton.isEnabled = true
      self?.cardNumberField.isEnabled = true

      switch result {
      case .success:
        let viewController = PersonalInfoViewController.storyboardInstance()!
        self?.navigationController?.pushViewController(viewController, animated: true)
      case .failure(let error):
        self?.cardNumberField.text = ""
        self?.presentErrorAlert(message: error.localizedDescription)
        self?.leftTries -= 1
      }
    }
  }

  @IBAction func skipButtonAction(_ sender: Any) {
    let viewController = PersonalInfoViewController.storyboardInstance()!
    navigationController?.pushViewController(viewController, animated: true)
  }

  var isValid: Bool = true {
    didSet {
      UIView.animate(withDuration: 0.2) { [weak self] in
        let isValid = self?.isValid ?? false
        self?.additionalViews.forEach {
          $0.isUserInteractionEnabled = !isValid
          $0.alpha = isValid ? 0 : 1
        }
        self?.confirmButton.alpha = isValid ? 1 : 0
        self?.confirmButton.isUserInteractionEnabled = isValid
        self?.iconDoneImageView.alpha = isValid ? 1 : 0
        self?.view.layoutIfNeeded()
      }
    }
  }

  let barCodeMaskedInput = MaskedInput(formattingType: .pattern("*  ******  ******"))

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logoNavbarRb"))
    isValid = false
    barCodeMaskedInput.configure(textField: cardNumberField)
    barCodeMaskedInput.returnHandler = { self.view.endEditing(true) }
    barCodeMaskedInput.isValidHandler = { self.isValid = $0 }

    leftTries = ProfileService.instance.cardInputTriesLeft
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
