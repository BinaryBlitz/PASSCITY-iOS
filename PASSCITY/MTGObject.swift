//
//  MTGObject.swift
//  PASSCITY
//
//  Created by Алексей on 21.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class MTGObject: Mappable, Hashable {
  var uuid: String = ""
  var title: String = ""
  var contentProviderId: String = ""
  var duration: Double = 0
  var distance: Double = 0
  var recent: Bool = true

  required init?(map: Map) { }

  func mapping(map: Map) {
    uuid <- map["uuid"]
    contentProviderId <- map["content_provider.uuid"]
    duration <- map["audio_duration"]
    if duration == 0 {
      duration <- map["duration"]
    }
    distance <- map["distance"]
    recent <- map["recent"]
    title <- map["title"]
  }

  var hashValue: Int {
    return uuid.hashValue
  }

  var isDownloaded: Bool {
    get {
      return UserDefaults.standard.value(forKey: uuid) as? Bool ?? false
    }
    set {
      UserDefaults.standard.set(newValue, forKey: uuid)
    }
  }

  public static func ==(lhs: MTGObject, rhs: MTGObject) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}

class MTGChildObject: MTGObject {
  var images: [MTGObject] = []
  var audio: [MTGObject] = []
  var children: [MTGChildObject] = []
  var triggerZones: TriggerZone? = nil
  var latitude: Double = 0
  var longitude: Double = 0

  var coordinate: CLLocationCoordinate2D? {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  override func mapping(map: Map) {
    super.mapping(map: map)
    audio <- map["audio"]
    images <- map["images"]
    children <- map["children"]
    triggerZones <- map["trigger_zones"]
    latitude <- map["location.latitude"]
    longitude <- map["location.longitude"]
  }

  class TriggerZone: Mappable {
    var latitude: Int = 0
    var longitude: Int = 0

    required init?(map: Map) { }

    func mapping(map: Map) {
      latitude <- map["circle_latitude"]
      longitude <- map["circle_longitude"]
    }
  }
  
}

class MTGFullObject: MTGObject {
  var latitude: Double = 0
  var longitude: Double = 0
  var content: [MTGChildObject] = []
  var ratingAverage: Float = 0.0
  var ratingsCount: Int = 0
  var name: String = ""

  override func mapping(map: Map) {
    super.mapping(map: map)
    distance <- map["distance"]
    content <- map["content"]
    latitude <- map["location.latitude"]
    longitude <- map["location.longitude"]
    ratingAverage <- map["reviews.rating_average"]
    ratingsCount <- map["reviews.ratings_count"]
    name <- map["name"]
  }

  var audioUrl: String {
    return content.first?.audio.first?.uuid ?? ""
  }

  func distanceTo(_ point: CLLocationCoordinate2D?) -> Double {
    guard let point = point else { return 0 }
    return pow(latitude - point.latitude, 2) + pow(longitude - point.longitude, 2)
  }
  
}
