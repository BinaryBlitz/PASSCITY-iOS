//
//  Constants.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 30.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

struct Constants {
 static let emailRegexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
 static let passCitySkipUrl = URL(string: "http://api.voxxter.ru/buttons/?order_id=8010&paytype=new&key=2192233720368547758&back=http%3A%2F%2Fpass.city%2F&lang=ru#/")!
}
