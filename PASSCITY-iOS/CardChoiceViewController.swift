//
//  CardChoiceViewController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import UIKit

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
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightBlack), range: title.range(of: "PASSCITY"))
  }

  var image: UIImage {
    switch self {
    case .card:
      return #imageLiteral(resourceName: "hasCardBack")
    case .noCard:
      return #imageLiteral(resourceName: "noCardBack")
    }
  }
}

class CardChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let logoView = UIImageView(image: logo)
  let chatButton = UIButton()
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
    tableView.tableFooterView = UIVIew()
    CardTableViewCell.register(in: tableView)

    chatButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)

  }

  func addConstraints() {
    view.addSubview(logoView)
    view.addSubview(tableView)
    view.addSubview(chatButton)

    logoView <- [
      Top(70),
      Bottom(70),
      CenterX()
    ]

    chatButton <- [
      CenterX(),
      Bottom(30)
    ]

    tableView <- [
      Top().to(logoView),
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
    return 2
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = CardTableViewCell.instance(tableView)!
    cell.configure(data: RegistrationTypeCellData(rawValue: indexPath.row))
    return cell
  }

}
