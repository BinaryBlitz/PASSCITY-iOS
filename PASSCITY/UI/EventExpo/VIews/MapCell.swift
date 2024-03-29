//
//  MapCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import EasyPeasy

class MapCell: UITableViewCell {
  let mapView = GMSMapView()
  var currentMarker: GMSMarker? = nil

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  init() {
    super.init(style: .default, reuseIdentifier: nil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    addSubview(mapView)
    mapView <- Edges()
  }

  func configure(coordinates: Coordinates, category: Category) {
    let marker = GMSMarker()
	currentMarker = marker
    marker.iconView = PasscityMarkerView(color: category.color ?? .red, iconUrl: category.icon)
    marker.position = coordinates.clLocationCoordinate2D!
	marker.map = mapView
	mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 14)
  }
}
