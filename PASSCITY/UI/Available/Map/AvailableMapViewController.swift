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
  var searchController: UISearchController!
  let searchResultsController = FeedItemsListViewController()

  var buttons: [UIButton] {
    return [audioGuideButton, zoomPlusButton, zoomMinusButton, myLocationButton]
  }

  var optionViews: [MenuOptionItemView] = AnnouncesMenuOptions.allValues.map { MenuOptionItemView(icon: $0.icon, title: $0.title )}

  var markers: [GMSMarker] = []

  override func viewDidLoad() {
    mapView = GMSMapView()
    mapView.delegate = self

    presenter = AvailableMapViewPresenter(view: self)

    zoom = 14

    setupView()
  }

  func setSearchItems(_ items: [PassCityFeedItem]) {
    searchResultsController.items = items
  }

  var isRefreshing: Bool = false {
    didSet {
      searchResultsController.isRefreshing = isRefreshing
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapView.isMyLocationEnabled = true
    RootViewController.instance?.configureMenuView(items: optionViews, handler: nil)
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

    cardView.buttonHandler = { [weak self] in
      self?.hideCardView()
    }
    addConstraints()
    setupSearchController()
  }

  func setupSearchController() {
    searchController = UISearchController(searchResultsController: searchResultsController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.searchBarStyle = .minimal
    searchController.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false

    searchResultsController.loadMoreHandler = { [weak self] in
      self?.presenter?.fetchSearchResults()
    }

    searchResultsController.moreButtonHandler = { _ in
      RootViewController.instance?.menuVisible = true
    }
  }

  var zoom: Int = 14 {
    didSet {
      presenter?.zoom = zoom
      mapView.animate(toZoom: Float(zoom))
    }
  }

  var coordinates: CLLocationCoordinate2D? = nil {
    didSet {
      guard let coordinates = coordinates else { return }
      mapView.camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: Float(zoom))
    }
  }

  func setMarkers(_ items: [PassCityFeedItem]) {
    markers.forEach { $0.map = nil }
    markers = []
    let categories = ProfileService.instance.currentSettings?.allCategories
    for item in items {
      DispatchQueue.main.async { [weak self] in
        let category = categories?.first { $0.id == item.category }
        let markerView = PasscityMarkerView(color: category?.color ?? UIColor.red, iconUrl: category?.icon)
        guard let coordinates = item.coordinates?.clLocationCoordinate2D else { return }
        let marker = GMSMarker()
        marker.position = coordinates
        marker.iconView = markerView
        marker.userData = item.id
        marker.isDraggable = false
        marker.map = self?.mapView
        self?.markers.append(marker)
      }
    }
  }

  func audioGuideAction() {
    let vc = AudioguidesListViewController()
    navigationController?.pushViewController(vc, animated: true)
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
      Height(100),
      Left(),
      Right(),
      Bottom(-100).to(bottomLayoutGuide)
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
      CenterY().with(.medium),
      Right(20)
    ]

    audioGuideButton <- [
      Bottom(20).to(cardView, .top),
      Right(20),
      Top(>=20).to(zoomMinusButton, .bottom).with(.high)
    ]

  }

  func hideCardView() {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }
      self.cardView <- [
        Bottom(-100).to(self.bottomLayoutGuide, .top)
      ]
      self.view.easy_reload()
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
    markers.forEach { newMarker in
      guard let view = newMarker.iconView as? PasscityMarkerView else { return }
      if false != view.isSelected {
        view.isHidden = true
        view.isSelected = false
        newMarker.iconView = view
        newMarker.iconView = nil
        newMarker.iconView = view
        newMarker.map = self.mapView
        view.isHidden = false
      }
    }

  }
}

extension AvailableMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let id = marker.userData as? Int else { return false }
    markers.forEach { newMarker in
      guard let markerId = newMarker.userData as? Int, let view = newMarker.iconView as? PasscityMarkerView else { return }
      let isSelected = id == markerId
      if isSelected != view.isSelected {
        view.isHidden = true
        view.isSelected = isSelected
        newMarker.iconView = view
        newMarker.iconView = nil
        newMarker.iconView = view
        newMarker.map = self.mapView
        view.isHidden = false
      }
    }
    prepareCardView(id: id)
    return true
  }

  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    hideCardView()
  }
}


extension AvailableMapViewController: UISearchResultsUpdating, UISearchControllerDelegate {

  func updateSearchResults(for searchController: UISearchController) {
    presenter?.searchText = searchController.searchBar.text ?? ""
  }

  func willDismissSearchController(_ searchController: UISearchController) {
    searchController.searchBar.text = ""
    presenter?.searchText = ""
    guard let parentVC = parent as? AvailableViewController else { return }
    parentVC.isSearching = false
  }

  func didPresentSearchController(_ searchController: UISearchController) {
    searchController.isActive = true
    DispatchQueue.main.async {
      searchController.searchBar.becomeFirstResponder()
    }
  }

}
