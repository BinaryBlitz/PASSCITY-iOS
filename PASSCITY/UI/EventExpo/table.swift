//
//  EvetExpoViewController.swift
//  PASSCITY
//
//  Created by Алексей on 02.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy


enum EventExpoScreenType {
  case event
  case expo
}

class EventExpoViewController: UITableViewController, TransparentViewController {
  let header = EventExpoHeaderView.nibInstance()!

  lazy var mapCell = MapCell()
  lazy var scheduleCell = ScheduleTableViewCell()
  lazy var addressCell = AddressCell()

  var addressCells: [UITableViewCell] {
    return [scheduleCell, addressCell, mapCell]
  }
  lazy var overallRatingCell = OverallRatingCell.nibInstance()!
  lazy var instructionCell = InstructionCell.nibInstance()!

  var loaderFooterView: LoaderView!

  var expandedAddressCell: Bool = false {
    didSet {
      scheduleCell.isExpanded = true
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }

  var item: PassCityFeedItem! {
    didSet {
      itemType = item.type
	  reconfigureStaticCells()
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.separatorStyle = isRefreshing ? .none : .singleLine
      tableView.backgroundView?.isHidden = !isRefreshing
      tableView.reloadData()
    }
  }

  var itemType: PassCityFeedItemType! {
    get {
      return header.screenType
    }
    set {
      header.screenType = newValue
	  reconfigureStaticCells()
    }
  }

  var headerExpoItem: ExpoHeaderItem = .address {
    didSet {
      tableView.reloadData()
    }
  }

  var headerEventItem: EventHeaderItem = .location {
    didSet {
      tableView.reloadData()
    }
  }

  func reconfigureStaticCells() {
	header.configure(item: item)
	scheduleCell.confure(item)
    scheduleCell.confure(item)
	header.tableView = tableView

	header.isActiveHandler = { [weak self] isActive in
		guard let `self` = `self` else { return }
		self.header.configure(item: self.item)
		self.tableView?.setTableHeaderView(headerView: self.header)
		self.view.layoutIfNeeded()
		self.view.updateConstraints()
		self.tableView?.reloadData()
		//self.updateLayout()
	}
    addressCell.configure(address: item.addressFull, contacts: item.contacts)
    instructionCell.configure(instructions: item.instruction)
    if let state = item.reviewsState {
      overallRatingCell.configure(reviewsState: state)
    }
    scheduleCell.isExpandedHanlder = { [weak self] _ in
		self?.tableView.beginUpdates()
		self?.tableView.endUpdates()
		self?.tableView.reloadData()

    }
	if let coordinates = item.coordinates, let category = item.categoryObject {
		mapCell.configure(coordinates: coordinates, category: category)
	}
	tableView.beginUpdates()
	tableView.endUpdates()
    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
	//view.safeAreaInsets.safeAreaLayoutGuide.translatesResiaingMasksIntoConstraints = false
	extendedLayoutIncludesOpaqueBars = true 
	automaticallyAdjustsScrollViewInsets = false
    MainTabBarController.instance.tabBarHidden = true
	reconfigureStaticCells()
  }

  override func viewDidLoad() {
    loaderFooterView = LoaderView(size: 64, frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    ItemsService.instance.fetchFullItem(item) { [weak self] result in
      switch result {
      case .success(let feedItem):
        self?.item = feedItem
		self?.reconfigureStaticCells()
      case .failure(_):
        break
      }
    }
    ResultFeedItemTableViewCell.register(in: tableView)
    automaticallyAdjustsScrollViewInsets = false
    extendedLayoutIncludesOpaqueBars = true
    MainTabBarController.instance.tabBarHidden = true
    tableView.backgroundColor = .white
    tableView.backgroundView = UIView()
    tableView.tableHeaderView = header
	//edgesForExtendedLayout = []
    ResultFeedItemTableViewCell.registerNib(in: tableView)
    tableView.separatorStyle = .singleLine
    ReviewTableViewCell.registerNib(in: tableView)
    tableView.tableFooterView = UIView()
    tableView.tableFooterView?.isHidden = true
    header.expoItemChanged = { [weak self] item in
      self?.headerExpoItem = item
    }

    header.eventItemChanged = { [weak self] item in
      self?.headerEventItem = item
    }

    reconfigureStaticCells()

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch itemType! {
    case .expo:
      switch headerExpoItem {
      case .address:
        return addressCells.count
      case .announces:
        return item.events.count
      case .instructions:
        return 1
      case .ratings:
        return 1 + (item.reviewsState?.data.count ?? 0)
      }
    case .event:
      switch  headerEventItem {

      case .location:
        return item.expos.count
      case .ratings:
        return 1 + (item.reviewsState?.data.count ?? 0)

      }
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch itemType! {
    case .event:
      switch headerEventItem {
      case .location:
        let expo = item.expos[indexPath.row]
        let cell = ResultFeedItemTableViewCell()
        cell.configure(expo)
        return cell
      case .ratings:
        if indexPath.row == 0 {
          return overallRatingCell
        } else {
          guard let rating = item.reviewsState?.data[indexPath.row - 1 ] else { return UITableViewCell() }
          let cell = ReviewTableViewCell.instance(tableView, indexPath)!
          cell.configure(review: rating)
          return cell

        }
      }
    case .expo:
      switch  headerExpoItem {
      case .address:
        return addressCells[indexPath.row]
      case .announces:
        let event = item.events[indexPath.row]
        let cell = ResultFeedItemTableViewCell.instance(tableView, indexPath)!
        cell.configure(event)
      case .instructions:
        return instructionCell
      case .ratings:
        if indexPath.row == 0 {
          return overallRatingCell
        } else {
          guard let rating = item.reviewsState?.data[indexPath.row - 1] else { return UITableViewCell() }
          let cell = ReviewTableViewCell.instance(tableView, indexPath)!
          cell.configure(review: rating)
          return cell

        }
      }
    }
    return UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch itemType! {
    case .event:
      switch headerEventItem {
      case .location:
        return 90
      case .ratings:
        if indexPath.row == 0 {
          return 210
        } else {
          return 200
        }
      }
    case .expo:
      switch  headerExpoItem {
      case .address:
        switch indexPath.row {
        case addressCells.index(of: scheduleCell)!:
          return UITableViewAutomaticDimension
        case addressCells.index(of: addressCell)!:
          return 124
        case addressCells.index(of: mapCell)!:
          return 200
        default:
          return UITableViewAutomaticDimension
      }
      case .instructions:
        return UITableViewAutomaticDimension
      case .announces:
        return 90
      case .ratings:
        if indexPath.row == 0 {
          return 220
        } else {
          return 200
        }
      }
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch itemType! {
    case .event:
      switch headerEventItem {
      case .location:
        return 90
      case .ratings:
        return 220
      }
    case .expo:
      switch  headerExpoItem {

      case .address:
        switch indexPath.row {
        case addressCells.index(of: scheduleCell)!:
          return scheduleCell.isExpanded ? 200 : 87
        case addressCells.index(of: addressCell)!:
          return 124
        default:
          return 0
        }
      case .instructions:
        return UITableViewAutomaticDimension
      case .announces:
        return 90
      case .ratings:
        return 220
      }
    }

  }

}
