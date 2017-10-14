//
//  ProductCardViewPresenter.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

protocol ProductCardView: BaseView {
  var product: PassCityProduct? { get set }
  var isRefreshing: Bool { get set }
}

class ProductCardViewPresenter {
  let view: ProductCardView
  var product: PassCityProduct {
    didSet {
      view.product = product
    }
  }

  var isRefreshing: Bool = false {
    didSet {
      view.isRefreshing = isRefreshing
    }
  }

  init(view: ProductCardView, product: PassCityProduct) {
    self.view = view
    self.product = product
    view.product = product
    fetchProduct()
  }

  func fetchProduct(_ completion: (() -> Void)? = nil) {
    guard !isRefreshing else {
      completion?()
      return
    }
    isRefreshing = true
    ItemsService.instance.fetchFullProduct(product) { [weak self] result in
      self?.isRefreshing = false
      completion?()
      switch result {
      case .success(let product):
        self?.product = product
      case .failure(_):
        break
      }
    }
  }

}
