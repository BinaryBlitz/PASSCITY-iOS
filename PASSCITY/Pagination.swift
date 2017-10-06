//
//  Pagination.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct Pagination: Mappable, Equatable {
  var currentPage: Int = 1
  var perPage: Int = 100
  var totalPages: Int? = nil

  init?(map: Map) { }

  init() { }

  mutating func mapping(map: Map) {
    currentPage <- map["current_page"]
    perPage <- map["per_page"]
    totalPages <- map["total_pages"]
  }

  static func ==(lhs: Pagination, rhs: Pagination) -> Bool {
    return lhs.totalPages == rhs.totalPages && lhs.perPage == rhs.perPage
  }
}
