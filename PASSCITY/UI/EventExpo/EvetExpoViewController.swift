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

class EventExpoViewController: UITableViewController, TransparentViewController, LightContentViewController {
  let header = EventExpoHeaderView.nibInstance()!

  lazy var mapCell = { MapCell() }()
  lazy var scheduleCell = { ScheduleTableViewCell() }()
  lazy var addressCell = { AddressCell() }()

  var addressCells: [UITableViewCell] {
    return [scheduleCell, addressCell, mapCell]
  }
  lazy var overallRatingCell = { OverallRatingCell() }()
  lazy var instructionCell = { InstructionCell() }()

  var loaderFooterView: LoaderView!


  var item: PassCityFeedItem! {
    didSet {
      header.configure(item: item)
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      tableView.separatorStyle = isRefreshing ? .none : .singleLine
      tableView.backgroundView?.isHidden = !isRefreshing
      tableView.reloadData()
    }
  }

  var screenType: EventExpoScreenType! {
    get {
      return header.screenType
    }
    set {
      header.screenType = newValue
    }
  }

  var headerExpoItem: ExpoHeaderItem! {
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
    scheduleCell.configure(item)
    addressCell.configure(address: item.addressFull, contacts: item.contacts)
    instructionCell.configure(instructions: item.instruction)
  }

  override func viewDidLoad() {
    ItemsService.instance.fetchFullItem(item) { [weak self] result in
      switch result {
      case .success(let feedItem):
        self?.item = feedItem
      case .failure(_):
        break
      }
    }
    ResultFeedItemTableViewCell.register(in: tableView)
    edgesForExtendedLayout = UIRectEdge()
    automaticallyAdjustsScrollViewInsets = false
    tableView.backgroundColor = .white
    tableView.backgroundView = UIView()
    //tableView.tableFooterView = UIView()
    ResultFeedItemTableViewCell.registerNib(in: tableView)
    tableView.separatorStyle = .singleLine
    ReviewTableViewCell.registerNib(in: tableView)
    tableView.tableFooterView = loaderFooterView
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)

    header.expoItemChanged = { [weak self] item in
      self?.headerExpoItem = item
    }

    header.eventItemChanged = { [weak self] item in
      self?.headerEventItem = item
    }

    reconfigureStaticCells()

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch screenType! {
    case .event:
      switch headerEventItem! {
      case .location:
        return item.expos.count
      case .ratings:
        return 1 + (item.reviewsState?.data.count ?? 0)
      }
    case .expo:
      switch  headerExpoItem! {
      case .address:
        return addressCells.count
      case .announces:
        return item.events.count
      case .instructions:
        return 1
      case .ratings:
        return 1 + (item.reviewsState?.data.count ?? 0)
      }
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch screenType! {
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
          let cell = ReviewTableViewCell()
          cell.configure(review: rating)
          return cell

        }
      }
    case .expo:
      switch  headerExpoItem! {
      case .address:
        return addressCells[indexPath.row]
      case .announces:
        let event = item.events[indexPath.row]
        let cell = ResultFeedItemTableViewCell()
        cell.configure(event)
      case .instructions:
        return instructionCell
      case .ratings:
        if indexPath.row == 0 {
          return overallRatingCell
        } else {
          guard let rating = item.reviewsState?.data[indexPath.row - 1] else { return UITableViewCell() }
          let cell = ReviewTableViewCell()
          cell.configure(review: rating)
          return cell

        }
      }
    }
  }
}
