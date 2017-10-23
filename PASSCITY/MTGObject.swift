//
//  IZITour.swift
//  PASSCITY
//
//  Created by Алексей on 21.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

class MTGObject: Mappable {
  var uuid: String = ""
  var title: String = ""

  var duration: Int = 0
  var distance: Int = 0

  required init?(map: Map) {
    <#code#>
  }

 func mapping(map: Map) {
    <#code#>
  }
}
