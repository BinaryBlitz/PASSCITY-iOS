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
  func setItems(_: [PassCityProduct])
  var isRefreshing: Bool { get set }
}

class AvailableProductsViewPresenter {
  let view: AvailableProductsView
  var currentItems: [PassCityProduct] = []
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

  func fetchProducts(reset: Bool = false, _ completion: (() -> Void)? = nil) {
    if pageLimit && !reset {
      completion?()
      return
    }
    guard !isRefreshing else {
      completion?()
      return
    }
    isRefreshing = true
    var filters = currentFilters
    filters.pagination.currentPage = reset ? 1 : filters.pagination.currentPage
    ItemsService.instance.fetchProducts(filters: filters) { [weak self] result in
      completion?()
      self?.isRefreshing = false
      switch result {
      case .success(let response):
        guard let `self` = self else { return }
        self.totalPages = 1
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

  func didSelectProduct(_ product: PassCityProduct) {
    let viewController = ProductCardViewController()
    viewController.presenter = ProductCardViewPresenter(view: viewController, product: product)
    view.pushViewController(viewController)
  }

}
