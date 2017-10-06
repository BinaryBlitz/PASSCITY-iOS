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
  var presenter: AvailableMapViewPresenter!
  let mapView = GMSMapView()
  let audioGuideButton = UIButton(type: .system)
  let zoomPlusButton = UIButton(type: .system)
  let zoomMinusButton = UIButton(type: .system)
  let myLocationButton = UIButton(type: .system)
  let cardView = PasscityMapCardView()

  var buttons: [UIButton] {
    return [audioGuideButton, zoomPlusButton, zoomMinusButton, myLocationButton]
  }

  override func viewDidLoad() {
    presenter = AvailableMapViewPresenter(view: self)
    mapView.delegate = self

    setupView()
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
    addConstraints()
  }

  var zoom: Int {
    get {
      return Int(mapView.camera.zoom)
    }
    set {
      presenter.zoom = zoom
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
    for item in items {
      let category = item.categoryObject
      let markerView = PasscityMarkerView(color: category?.color ?? UIColor.red, iconUrl: category?.icon)
      guard let coordinates = item.coordinates?.clLocationCoordinate2D else { return }
      let marker = GMSMarker()
      marker.position = coordinates
      marker.iconView = markerView

      marker.isDraggable = false
      marker.map = mapView
      marker.userData = index
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
  }

  func prepareCardView(id: Int) {
    guard let item = presenter.currentItems.first(where: { $0.id == id }) else { return }
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
      Left(20)
    ]

    myLocationButton <- [
      Top(20),
      Right(20)
    ]

    let zoomButtonsView = UIView()
    zoomButtonsView.backgroundColor = .clear

    zoomButtonsView.addSubview(zoomPlusButton)
    zoomButtonsView.addSubview(zoomMinusButton)

    zoomPlusButton <- [
      Top(),
      Left(),
      Right()
    ]

    zoomMinusButton <- [
      Top(20).to(zoomPlusButton),
      Bottom(),
      Left(),
      Right()
    ]

    zoomButtonsView <- [
      CenterY(),
      Right(20)
    ]

  }
}

extension AvailableMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let id = marker.userData as? Int else { return false }
    prepareCardView(event: events[index])
    return true
  }

  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }
      self.bottomCardConstraint.constant = -self.cardHeightConstraint.constant
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
  }
}
