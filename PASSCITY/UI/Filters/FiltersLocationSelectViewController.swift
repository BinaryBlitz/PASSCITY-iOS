//
//  FiltersLocationSelectViewController.swift
//  PASSCITY
//
//  Created by Алексей on 30.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import EasyPeasy

private enum Sections: Int {
  case staticCells = 0
  case results

  static let allValues = [staticCells, results]
}

class FiltersLocationSelectViewController: UITableViewController {
  var categories: [Category] {
    return ProfileService.instance.currentSettings?.categories ?? []
  }

  let client = GMSPlacesClient()

  var handler: ((Coordinates?) -> Void)? = nil
  var selectedCoordinates: Coordinates? = nil {
    didSet {
      locationInputField.text = selectedCoordinates?.name
      handler?(nearbySwitchCell.isOn ? nil : selectedCoordinates)
    }
  }

  var predictions: [GMSAutocompletePrediction] = [] {
    didSet {
      tableView.reloadSections(IndexSet(integer: Sections.results.rawValue), with: .automatic)
    }
  }

  var selectedPrediction: GMSAutocompletePrediction? {
    didSet {
      tableView.reloadSections(IndexSet(integer: Sections.results.rawValue), with: .automatic)
    }
  }

  let locationInputCell = UITableViewCell()
  let locationInputField = UITextField()
  let nearbySwitchCell = SwitchTableViewCell("Поблизости")

  private var refreshSearchAction: (() -> Void)? = nil

  var staticCells: [UITableViewCell] {
    return [locationInputCell, nearbySwitchCell]
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nearbySwitchCell.isOn = selectedCoordinates == nil
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    extendedLayoutIncludesOpaqueBars = false
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)

    locationInputCell.addSubview(locationInputField)
    locationInputField <- [
      Left(20),
      Top(),
      Right(),
      Bottom()
    ]
    locationInputField.placeholder = "Укажите город, улицу или дом"
    locationInputField.delegate = self
    locationInputField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    tableView.tableFooterView = UIView()
    locationInputField.font = UIFont.systemFont(ofSize: 15)
    locationInputField.text = selectedCoordinates?.name
    self.refreshSearchAction = debounce(delay: .seconds(1)) { [weak self] in
      self?.client.autocompleteQuery(self?.locationInputField.text ?? "", bounds: nil, filter: nil, callback: { (predictions, _) in
        self?.predictions = predictions ?? []
      })
    }

    title = "Локация"
    nearbySwitchCell.handler = { [weak self] isOn in
      if isOn {
        self?.selectedPrediction = nil
      }
      self?.tableView.reloadData()
    }
    refreshSearchAction?()
  }

  func textFieldChanged() {
    refreshSearchAction?()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allValues.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let currentSection = Sections(rawValue: section)!
    switch currentSection {
    case .staticCells:
      return staticCells.count
    case .results:
      return predictions.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let currentSection = Sections(rawValue: indexPath.section)!
    switch currentSection {
    case .staticCells:
      return staticCells[indexPath.row]
    case .results:
      let cell = UITableViewCell()
      let prediction = predictions[indexPath.row]
      cell.textLabel?.attributedText = prediction.attributedFullText
      cell.accessoryType = selectedPrediction == prediction ? .checkmark : .none
      cell.textLabel?.alpha = nearbySwitchCell.isOn ? 0.6 : 1.0
      cell.tintColor = UIColor.red
      cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
      cell.textLabel?.textColor = UIColor.black
      return cell
    }
  }

  func updateLayout() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarController.instance.playerWidgetHeight, right: 0)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let prediction = predictions[indexPath.row]
    guard let placeID = prediction.placeID, !nearbySwitchCell.isOn else { return }
    selectedPrediction = prediction
    client.lookUpPlaceID(placeID) { [weak self] (place, error) in
      guard let place = place else { return }
      if self?.selectedPrediction?.placeID == placeID && !(self?.nearbySwitchCell.isOn ?? false) {
        var coordinates = Coordinates(place.coordinate)
        coordinates?.name = place.name
        self?.selectedCoordinates = coordinates
      }
    }
  }

}

extension FiltersLocationSelectViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }

}
