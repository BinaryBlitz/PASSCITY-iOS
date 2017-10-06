//
//  AvailableMapViewController.swift
//  PASSCITY
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import EasyPeasy

class AvailableMapViewController: UIViewController, AvailableMapView {
  let animationDuration = 0.2
  var presenter: AvailableMapViewPresenter? = nil
  var mapView: GMSMapView!
  let audioGuideButton = UIButton()
  let zoomPlusButton = UIButton()
  let zoomMinusButton = UIButton()
  let myLocationButton = UIButton()
  let cardView = PasscityMapCardView.nibInstance()!

  var buttons: [UIButton] {
    return [audioGuideButton, zoomPlusButton, zoomMinusButton, myLocationButton]
  }

  var markers: [GMSMarker] = []

  override func viewDidLoad() {
    mapView = GMSMapView()
    mapView.delegate = self

    presenter = AvailableMapViewPresenter(view: self)

    setupView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapView.isMyLocationEnabled = true
    presenter?.updateLocation()
  }

  func setupView() {
    audioGuideButton.setImage(#imageLiteral(resourceName: "iconButtonMapAudiotours"), for: .normal)
    zoomPlusButton.setImage(#imageLiteral(resourceName: "iconButtonMapZoomIn"), for: .normal)
    zoomMinusButton.setImage(#imageLiteral(resourceName: "iconButtonMapZoomOut"), for: .normal)
    myLocationButton.setImage(#imageLiteral(resourceName: "iconButtonMapLocation"), for: .normal)

    audioGuideButton.addTarget(self, action: #selector(audioGuideAction), for: .touchUpInside)
    zoomPlusButton.addTarget(self, action: #selector(zoomPlusAction), for: .touchUpInside)
    zoomMinusButton.addTarget(self, action: #selector(zoomMinusAction), for: .touchUpInside)
    myLocationButton.addTarget(self, action: #selector(myLocationAction), for: .touchUpInside)

    cardView.closeButtonHandler = { [weak self] in
      self?.hideCardView()
    }
    addConstraints()
  }

  var zoom: Int {
    get {
      return Int(mapView.camera.zoom)
    }
    set {
      presenter?.zoom = newValue
      mapView.animate(toZoom: Float(newValue))
    }
  }

  var coordinates: CLLocationCoordinate2D? = nil {
    didSet {
      guard let coordinates = coordinates else { return }
      mapView.camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: Float(zoom))
    }
  }

  func setMarkers(_ items: [PassCityFeedItemShort]) {
    markers.forEach { $0.map = nil }
    markers = []
    for item in items {
      let category = item.categoryObject
      let markerView = PasscityMarkerView(color: category?.color ?? UIColor.red, iconUrl: category?.icon)
      guard let coordinates = item.coordinates?.clLocationCoordinate2D else { return }
      let marker = GMSMarker()
      marker.position = coordinates
      marker.iconView = markerView
      marker.userData = item.id
      marker.isDraggable = false
      marker.map = self.mapView
      markers.append(marker)
    }
  }

  func audioGuideAction() {

  }

  func zoomPlusAction() {
    zoom += 1
  }

  func zoomMinusAction() {
    zoom -= 1
  }

  func myLocationAction() {
    mapView.isMyLocationEnabled = true
    presenter?.updateLocation()
  }

  func prepareCardView(id: Int) {
    guard let item = presenter?.currentItems.first(where: { $0.id == id }) else { return }
    cardView.configure(item: item)

    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }

      self.cardView <- [
        Bottom().to(self.bottomLayoutGuide, .bottom)
      ]
      self.view.easy_reload()
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
  }

  func addConstraints() {
    view.addSubview(mapView)
    view.addSubview(audioGuideButton)
    view.addSubview(cardView)
    view.addSubview(myLocationButton)

    mapView <- Edges()

    cardView <- [
      Height(90),
      Left(),
      Right(),
      Bottom(-90).to(bottomLayoutGuide)
    ]

    audioGuideButton <- [
      Bottom(20).to(cardView, .top),
      Right(20)
    ]

    myLocationButton <- [
      Top(20),
      Right(20)
    ]

    let zoomButtonsView = UIView()
    view.addSubview(zoomButtonsView)

    zoomButtonsView.backgroundColor = .clear

    zoomButtonsView.addSubview(zoomPlusButton)
    zoomButtonsView.addSubview(zoomMinusButton)

    zoomPlusButton <- [
      Top(),
      Left(),
      Right()
    ]

    zoomMinusButton <- [
      Top(20).to(zoomPlusButton, .bottom),
      Bottom(),
      CenterX().to(zoomPlusButton)
    ]

    zoomButtonsView <- [
      CenterY(),
      Right(20)
    ]

  }

  func hideCardView() {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }
      self.cardView <- [
        Bottom(-90).to(self.bottomLayoutGuide, .top)
      ]
      self.view.easy_reload()
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }

  }
}

extension AvailableMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let id = marker.userData as? Int else { return false }
    prepareCardView(id: id)
    return true
  }

  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    hideCardView()
  }
}
