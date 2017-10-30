//
//  AvailableMapViewPresenter.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import CoreLocation

protocol AvailableMapView: BaseView {
  func setMarkers(_: [PassCityFeedItemShort])
  func setSearchItems(_: [PassCityFeedItemShort])
  var zoom: Int { get set }
  var coordinates: CLLocationCoordinate2D? { get set }
  var isRefreshing: Bool { get set }
}

class AvailableMapViewPresenter: NSObject {
  let view: AvailableMapView
  let locationManager = CLLocationManager()
  var currentItems = Set<PassCityFeedItemShort>()
  var currentSearchItems: [PassCityFeedItemShort] = []
  var currentFilters = EventsFiltersState() {
    didSet {
      guard currentFilters != oldValue else { return }
      currentPage = 1
      currentItems = Set()
      if let coordinates = currentFilters.filter.coordinates, coordinates != oldValue.filter.coordinates {
        view.coordinates = coordinates.clLocationCoordinate2D
      }
      fetchMap()
    }
  }

  private var refreshSearchAction: (() -> Void)? = nil
  var searchText: String = "" {
    didSet {
      view.setSearchItems(searchText.isEmpty ? currentSearchItems : currentSearchItems.filter { $0.title.lowercased().contains(searchText.lowercased())})
      refreshSearchAction?()
    }
  }

  var totalSearchPages: Int? = nil
  var currentSearchPage: Int {
    get {
      return currentSearchFilters.pagination.currentPage
    }
    set {
      currentSearchFilters.pagination.currentPage = newValue
    }
  }

  var currentSearchFilters = EventsFiltersState() {
    didSet {
      guard currentSearchFilters != oldValue else { return }
      currentSearchPage = 1
      fetchSearchResults(reset: true)
    }
  }


  var searchPageLimit: Bool {
    let totalPages = self.totalPages ?? 1
    return currentPage > totalPages
  }

  var totalPages: Int? = nil

  var currentPage: Int {
    get {
      return currentFilters.pagination.currentPage
    }
    set {
      currentFilters.pagination.currentPage = newValue
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      view.isRefreshing = isRefreshing
    }
  }

  var pageLimit: Bool {
    let totalPages = self.totalPages ?? 1
    return currentPage > totalPages
  }

  var zoom: Int = 14 {
    didSet {
      currentPage = 1
      fetchMap()
    }
  }

  init(view: AvailableMapView) {
    self.view = view
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

    self.currentFilters = EventsFiltersState()
    var coordinates = Coordinates.current
    coordinates?.mapScale = zoom
    view.zoom = zoom
    view.coordinates = coordinates?.clLocationCoordinate2D

    self.refreshSearchAction = debounce(delay: .seconds(1)) { [weak self] in
      guard let filters = self?.currentFilters, var currentSearchFilters = self?.currentSearchFilters else { return }
      currentSearchFilters.filter = filters.filter
      currentSearchFilters.filter.coordinates?.mapScale = nil
      currentSearchFilters.search = self?.searchText ?? ""
      currentSearchFilters.pagination.currentPage = 1
      self?.currentSearchFilters = currentSearchFilters
    }
  }

  func updateLocation() {
    locationManager.startUpdatingLocation()
  }

  var currentLocation: Coordinates? = nil {
    didSet {
      if currentFilters.filter.coordinates == nil {
        view.zoom = zoom
        view.coordinates = currentLocation?.clLocationCoordinate2D
      }
    }
  }

  func fetchMap() {
    guard !pageLimit else { return }
    isRefreshing = true
    var filters = currentFilters
    if filters.filter.coordinates == nil {
      filters.filter.coordinates = currentLocation
      filters.filter.coordinates?.mapScale = zoom
    }
    ItemsService.instance.fetchEvents(target: .getMap(filters)) { [weak self] result in
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self else { return }
        self.totalPages = response.state.pagination.totalPages
        self.currentItems.formUnion(response.objects)
        self.view.setMarkers(Array(self.currentItems))
        self.currentPage += 1
        self.fetchMap()
      case .failure(_):
        self?.isRefreshing = false
      }
    }
  }

  func fetchSearchResults(reset: Bool = false) {
    guard !searchPageLimit || reset else { return }
    isRefreshing = true
    var filters = currentSearchFilters
    if filters.filter.coordinates == nil {
      filters.filter.coordinates = currentLocation
      filters.filter.coordinates?.mapScale = zoom
    }
    ItemsService.instance.fetchEvents(target: .getMap(filters)) { [weak self] result in
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self else { return }
        self.totalSearchPages = response.state.pagination.totalPages
        if reset || self.currentSearchPage == 1 {
          self.currentSearchItems = response.objects
        } else {
          self.currentSearchItems.append(contentsOf: response.objects)
        }
        self.view.setSearchItems(self.currentSearchItems)
        self.currentSearchPage += 1
      case .failure(_):
        self?.isRefreshing = false
      }
    }
  }

}

extension AvailableMapViewPresenter: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    manager.stopUpdatingLocation()
    currentLocation = Coordinates(location.coordinate)
  }

}
