//
//  NotificationService.swift
//  PASSCITY
//
//  Created by Алексей on 30.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

private let categoryIdentifier = "temp"

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
  static let instance = NotificationService()
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
  }

  func configure() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
    })
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }

  static func show(_ title: String = "Alert!", subtitle: String = "", body: String = "  ") {

    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.badge = 1
    content.categoryIdentifier = categoryIdentifier

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let requestIdentifier = categoryIdentifier
    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
      guard let error = error else { return }
      debugPrint(error)
    })
  }

}
