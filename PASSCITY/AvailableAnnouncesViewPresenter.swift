//
//  AvailableAnnouncesViewPresenter.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import CoreLocation

protocol AvailableAnnouncesView: BaseView {
  func setItems(_: [PassCityFeedItemShort])
}

class AvailableMapViewPresenter: NSObject {
  let view: AvailableMapView
  let locationManager = CLLocationManager()
  var currentItems = Set<PassCityFeedItemShort>()
  var currentFilters = EventsFiltersState() {
    didSet {
      guard currentFilters != oldValue else { return }
      currentPage = 1
      fetchMap()
    }
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

  var isRefreshing: Bool = false

  var pageLimit: Bool {
    let totalPages = self.totalPages ?? 1
    return currentPage > totalPages
  }

  var zoom: Int = 15 {
    didSet {
      var currentFilters = self.currentFilters
      var coordinates = currentFilters.filter.coordinates
      coordinates?.mapScale = zoom
      currentFilters.filter.coordinates = coordinates
      self.currentFilters = currentFilters
    }
  }

  init(view: AvailableMapView) {
    self.view = view
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

    var currentFilters = EventsFiltersState()
    var coordinates = Coordinates.current
    coordinates?.mapScale = zoom
    currentFilters.filter.coordinates = coordinates
    self.currentFilters = currentFilters
    view.zoom = zoom
    view.coordinates = coordinates?.clLocationCoordinate2D
  }

  func updateLocation() {
    locationManager.startUpdatingLocation()
  }

  func setLocation(_ location: CLLocationCoordinate2D) {
    var currentFilters = self.currentFilters
    var coordinates = Coordinates(location)
    coordinates?.mapScale = zoom
    currentFilters.filter.coordinates = coordinates
    self.currentFilters = currentFilters
    view.zoom = zoom
    view.coordinates = coordinates?.clLocationCoordinate2D
  }

  func fetchMap() {
    guard !pageLimit else { return }
    isRefreshing = true
    let filters = currentFilters
    ShortEventsService.instance.fetchEvents(target: .getMap(filters)) { [weak self] result in
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self, filters == self.currentFilters else { return }
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

}
