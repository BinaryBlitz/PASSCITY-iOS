//
//  AudioguideCardViewController.swift
//  PASSCITY
//
//  Created by Алексей on 22.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import GoogleMaps

class AudioguideCardViewController: UIViewController, LightContentViewController, TransparentViewController {
  let headerView = AudioguideCardHeaderView.nibInstance()!
  let contentContainerView = UIView()
  let listTableView = AudioguideCardItemsListTableView()
  var mapView = GMSMapView()
  var markers: [GMSMarker] = []

  var currentItem: AudioguideScreenItem = .list {
    didSet {
      headerView.currentItem = currentItem
      switch currentItem {
      case .map:
        currentView = mapView
      default:
        currentView = listTableView
      }
    }
  }

  var tour: MTGFullObject? = nil {
    didSet {
      guard let tour = tour else { return }
      headerView.configure(tour)
      listTableView.tour = tour
      if let coordinate = tour.coordinate {
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14)
      }
      setMarkers()
    }
  }

  var shortTour: MTGChildObject? = nil {
    didSet {
      guard let shortTour = shortTour else { return }
      refresh()
      headerView.configure(shortTour)
    }
  }

  var currentView: UIView? = nil {
    didSet {
      oldValue?.removeFromSuperview()

      guard let newView = currentView else { return }
      contentContainerView.addSubview(newView)
      newView <- [
        Edges(),
        Width().like(view)
      ]
      view.updateConstraints()
      view.layoutIfNeeded()
    }
  }

  var rectangle: GMSPolyline? = nil {
    didSet {
      oldValue?.map = nil
    }
  }

  func configure() {
  }

  func refresh() {
    if let id = shortTour?.uuid {
      tour = AudioguidesService.instande.fullTours.first(where: { $0.uuid == id })
    }
    _ = AudioguidesService.instande.fetchAudioguide(id: shortTour?.uuid ?? "", { [weak self] result in
      switch result {
      case .success(let guide):
        self?.tour = guide
      case .failure(_):
        return
      }
    })
  }

  func setMarkers() {
    markers.forEach { $0.map = nil }
    markers = []
    let path = GMSMutablePath()
    for (offset, item) in (tour?.content.first?.children ?? []).enumerated() {
      let markerView = AudioguideCardPlayingItemMarkerView()
      markerView.configure(index: offset, isPlaying: AudioguidesPlayer.instance.isPlaying(tourId: tour?.uuid ?? "", itemId: item.uuid))
      guard let coordinates = item.coordinate else { return }
      path.add(coordinates)
      let marker = GMSMarker()
      marker.position = coordinates
      marker.iconView = markerView
      marker.userData = item.uuid
      marker.isDraggable = false
      marker.map = mapView
      marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
      markers.append(marker)
    }
    rectangle = GMSPolyline(path: path)
    rectangle?.strokeWidth = 2
    rectangle?.strokeColor = UIColor.seafoamBlue
    rectangle?.map = mapView
  }


  override func viewDidLoad() {
    mapView.delegate = self
    automaticallyAdjustsScrollViewInsets = false

    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    view.addSubview(headerView)
    view.addSubview(contentContainerView)

    headerView <- [
      Top(),
      Left(),
      Right()
    ]

    contentContainerView <- [
      Top().to(headerView),
      Left(),
      Right(),
      Bottom()
    ]

    currentView = listTableView
    configureHandlers()
  }

  func configureHandlers() {
    listTableView.updateLayoutHanlder = { [weak self] in
      self?.updateLayout()
    }

    headerView.downloadHandler = { [weak self] in
      guard let tourId = self?.shortTour?.uuid ?? self?.tour?.uuid else { return }
      AudioguidesPlayer.instance.downloadTour(tourId: tourId)
    }

    headerView.itemChangedHandler = { [weak self] item in
      self?.currentItem = item
    }
  }

  func updateLayout() {
    contentContainerView <- [
      Top().to(headerView),
      Left(),
      Right(),
      Bottom(MainTabBarController.instance.playerWidgetHeight)
    ]
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
    updateLayout()
  }

}

extension AudioguideCardViewController: GMSMapViewDelegate {

}
