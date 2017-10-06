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

class ShortEventsService {
  static let instance = ShortEventsService()
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

struct EventsFiltersState: Mappable, Equatable {
  var filter: PassCityFeedItemFilter = PassCityFeedItemFilter()
  var search: String = ""
  var pagination: Pagination = Pagination()

  init?(map: Map) { }

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
