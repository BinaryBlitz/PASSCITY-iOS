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

class AvailableAnnouncesViewPresenter {
  let view: AvailableAnnouncesView
  var currentItems = Set<PassCityFeedItemShort>()
  var currentFilters = EventsFiltersState() {
    didSet {
      guard currentFilters != oldValue else { return }
      currentPage = 1
      fetchAnnounces()
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

  init(view: AvailableAnnouncesView) {
    self.view = view

    var currentFilters = EventsFiltersState()
    let coordinates = Coordinates.current
    currentFilters.filter.coordinates = coordinates
    self.currentFilters = currentFilters
  }

  func fetchAnnounces() {
    guard !pageLimit else { return }
    guard !isRefreshing else { return }
    isRefreshing = true
    let filters = currentFilters
    ShortEventsService.instance.fetchEvents(target: .getAnnounces(filters)) { [weak self] result in
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self, filters == self.currentFilters else { return }
        self.totalPages = response.state.pagination.totalPages
        self.currentItems.formUnion(response.objects)
        self.view.setItems(Array(self.currentItems))
        self.currentPage += 1
      case .failure(_):
        self?.isRefreshing = false
      }
    }
  }

}
