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
  var isRefreshing: Bool { get set }
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

  var isRefreshing: Bool = false {
    didSet {
      view.isRefreshing = isRefreshing
    }
  }

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

  func fetchAnnounces(increasePage: Bool = true, _ completion: (() -> Void)? = nil) {
    if pageLimit && increasePage {
      completion?()
      return
    }
    guard !isRefreshing else { return }
    isRefreshing = true
    var filters = currentFilters
    filters.pagination.currentPage = !increasePage ? filters.pagination.currentPage : 1
    ShortEventsService.instance.fetchEvents(target: .getAnnounces(filters)) { [weak self] result in
      completion?()
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self else { return }
        self.totalPages = 1
        self.currentItems.formUnion(response.objects)
        self.view.setItems(Array(self.currentItems))
        self.currentPage += 1
      case .failure(_):
        self?.isRefreshing = false
      }
    }
  }

}
