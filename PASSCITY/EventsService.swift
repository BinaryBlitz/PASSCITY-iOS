//
//  EventsService.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class ItemsService {
  static let instance = ItemsService()
  private init() { }
  
  private let itemsProvider = JSONAPIProvider<AvailableItemsTarget>()

  func fetchEvents(target: AvailableItemsTarget, _ completion: @escaping ServiceCompletion<PassCityFeedItemResponse>) {
    itemsProvider.callAPI(target) { result in
      switch result {
      case .success(let response):
        guard let feedResponse = Mapper<PassCityFeedItemResponse>().map(JSONObject: response.data) else {
          return completion(.failure(DataError.serializationError(response.data)))
        }
        return completion(.success(feedResponse))
      case .failure(let error):
        return completion(.failure(error))
      }
    }
  }

  func fetchProducts(filters: ProductsFiltersState, _ completion: @escaping ServiceCompletion<PassCityProductsResponse>) {
    itemsProvider.callAPI(.getProducts(filters)) { result in
      switch result {
      case .success(let response):
        guard let feedResponse = Mapper<PassCityProductsResponse>().map(JSONObject: response.data) else {
          return completion(.failure(DataError.serializationError(response.data)))
        }
        return completion(.success(feedResponse))
      case .failure(let error):
        return completion(.failure(error))
      }
    }
  }

  func fetchFullProduct(_ product: PassCityProduct, _ completion: @escaping ServiceCompletion<PassCityProduct>) {
    itemsProvider.callAPI(.getProduct(type: product.type, id: product.id)) { result in
      switch result {
      case .success(let response):
        guard let feedResponse = Mapper<PassCityProduct>().map(JSONObject: response.data) else {
          return completion(.failure(DataError.serializationError(response.data)))
        }
        return completion(.success(feedResponse))
      case .failure(let error):
        return completion(.failure(error))
      }
    }
  }

}

struct PassCityFeedItemResponse: Mappable {
  var state: EventsFiltersState = EventsFiltersState()
  var objects: [PassCityFeedItemShort] = []
  var audioguides: Int = 0

  init?(map: Map) {
    state = EventsFiltersState(map: map) ?? EventsFiltersState()
  }

  init() { }

 mutating func mapping(map: Map) {
    state.mapping(map: map)
    objects <- map["objects"]
    audioguides <- map["audioguides"]
  }

}

struct PassCityProductsResponse: Mappable {
  var state: ProductsFiltersState = ProductsFiltersState()
  var objects: [PassCityProduct] = []

  init?(map: Map) {
    state = ProductsFiltersState(map: map) ?? ProductsFiltersState()
  }
  
  init() { }
  
  mutating func mapping(map: Map) {
    state.mapping(map: map)
    objects <- map["objects"]
  }
  
}


struct ProductsFiltersState: Mappable, Equatable {
  var search: String = ""
  var pagination: Pagination = Pagination()
  var filter: ProductsFilter = ProductsFilter()

  init?(map: Map) {
    self.mapping(map: map)
  }

  init() { }

  mutating func mapping(map: Map) {
    search <- map["search"]
    pagination <- map["pagination"]
    filter <- map["filter"]
  }

  static func ==(lhs: ProductsFiltersState, rhs: ProductsFiltersState) -> Bool {
    return lhs.search == rhs.search && lhs.pagination == rhs.pagination && lhs.filter == rhs.filter
  }
}


struct EventsFiltersState: Mappable, Equatable {
  var filter: PassCityFeedItemFilter = PassCityFeedItemFilter()
  var search: String = ""
  var pagination: Pagination = Pagination()

  init?(map: Map) {
    self.mapping(map: map)
  }

  init() { }

  mutating func mapping(map: Map) {
    filter <- map["filter"]
    search <- map["search"]
    pagination <- map["pagination"]
  }

  static func ==(lhs: EventsFiltersState, rhs: EventsFiltersState) -> Bool {
    return lhs.filter == rhs.filter && lhs.search == rhs.search && lhs.pagination == rhs.pagination
  }
}
