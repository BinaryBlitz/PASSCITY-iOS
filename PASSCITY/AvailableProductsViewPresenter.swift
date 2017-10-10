//
//  AvailableProductsViewPresenter.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import CoreLocation

protocol AvailableProductsView: BaseView {
  func setItems(_: [PassCityProductShort])
  var isRefreshing: Bool { get set }
}

class AvailableProductsViewPresenter {
  let view: AvailableProductsView
  var currentItems = Set<PassCityProductShort>()
  var currentFilters = ProductsFiltersState() {
    didSet {
      guard currentFilters != oldValue else { return }
      currentPage = 1
      fetchProducts()
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

  init(view: AvailableProductsView) {
    self.view = view

    self.currentFilters = ProductsFiltersState()
  }

  func fetchProducts(_ completion: (() -> Void)? = nil) {
    guard !pageLimit else { return }
    guard !isRefreshing else { return }
    isRefreshing = true
    let filters = currentFilters
    ShortEventsService.instance.fetchProducts(filters: filters) { [weak self] result in
      completion?()
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self, filters == self.currentFilters else { return }
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
