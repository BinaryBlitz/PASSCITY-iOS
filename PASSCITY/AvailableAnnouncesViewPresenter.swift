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
  var currentItems: [PassCityFeedItemShort] = []
  var currentFilters = EventsFiltersState() {
    didSet {
      guard currentFilters != oldValue else { return }
      currentPage = 1
      currentItems = []
      fetchAnnounces(reset: true)
    }
  }

  var searchText: String = "" {
    didSet {
      view.setItems( searchText.isEmpty ? currentItems : currentItems.filter { $0.title.lowercased().contains(searchText.lowercased())} )
      refreshSearchAction?()
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
    self.currentFilters = EventsFiltersState()

    self.refreshSearchAction = debounce(delay: .seconds(1)) { [weak self] in
      guard var filters = self?.currentFilters else { return }
      filters.search = self?.searchText ?? ""
      self?.currentFilters = filters
    }
  }

  func fetchAnnounces(reset: Bool = false, _ completion: (() -> Void)? = nil) {
    if pageLimit && !reset {
      completion?()
      return
    }
    guard !isRefreshing else { return }
    isRefreshing = true
    var filters = currentFilters
    if filters.filter.coordinates == nil {
      filters.filter.coordinates = Coordinates.current
    }
    filters.pagination.currentPage = reset ? 1 : filters.pagination.currentPage
    ItemsService.instance.fetchEvents(target: .getAnnounces(filters)) { [weak self] result in
      completion?()
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self else { return }
        self.totalPages = response.state.pagination.totalPages ?? 1
        if reset {
          self.currentItems = response.objects
        } else {
          self.currentItems.append(contentsOf: response.objects)
        }
        self.view.setItems(self.currentItems)
        self.currentPage += 1
      case .failure(_):
        self?.isRefreshing = false
      }
    }
  }

  private var refreshSearchAction: (() -> Void)? = nil

}
