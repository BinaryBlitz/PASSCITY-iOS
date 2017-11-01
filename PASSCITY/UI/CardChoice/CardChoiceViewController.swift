//
//  CardChoiceViewController.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import UIKit
import EasyPeasy

enum RegistrationTypeCellData: Int {
  case card = 0
  case noCard

  var title: String {
    switch self {
    case .card:
      return "У меня есть\nкарта PASSCITY"
    case .noCard:
      return "У меня нет\nкарты PASSCITY"
    }
  }

  var titleAttributed: NSAttributedString {
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 22.0), range: NSRange(location: 0, length: title.characters.count))
    let nsTitle = title as NSString
    let textRange = NSMakeRange(0, nsTitle.length)

    nsTitle.enumerateSubstrings(in: textRange, options: .byWords, using: {
      (substring, substringRange, _, _) in
      if substring == "PASSCITY" {
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightBlack), range: substringRange)
      }
    })
    return attributedString
  }

  var image: UIImage {
    switch self {
    case .card:
      return #imageLiteral(resourceName: "hasCardBack")
    case .noCard:
      return #imageLiteral(resourceName: "noCardBack")
    }
  }

  static let count = 2
}

class CardChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
  let chatButton = UIButton(type: .system)
  let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    setupView()
    addConstraints()
  }

  func setupView() {
    view.backgroundColor = UIColor.white
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.bounces = false
    tableView.isScrollEnabled = false
    tableView.tableFooterView = UIView()
    CardTableViewCell.register(in: tableView)

    chatButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
    chatButton.tintColor = .black

  }

  func addConstraints() {
    view.addSubview(logoView)
    view.addSubview(tableView)
    view.addSubview(chatButton)

    logoView <- [
      Top(70),
      CenterX(),
      Height(26)
    ]

    chatButton <- [
      CenterX(),
      Bottom(30)
    ]

    tableView <- [
      Top(70).to(logoView),
      Bottom().to(chatButton),
      Left(),
      Right()
    ]
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RegistrationTypeCellData.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = CardTableViewCell.instance(tableView)!
    cell.configure(data: RegistrationTypeCellData(rawValue: indexPath.row)!)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let data = RegistrationTypeCellData(rawValue: indexPath.row)!
    switch data {
    case .card:
      let cardEntryViewController = CardEntryViewController.storyboardInstance()!
      navigationController?.pushViewController(cardEntryViewController, animated: true)
    case .noCard:
      let infoViewController = PersonalInfoViewController.storyboardInstance()!
      navigationController?.pushViewController(infoViewController, animated: true)
    }
  }

}
