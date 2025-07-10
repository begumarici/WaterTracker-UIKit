//
//  Constants.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 4.07.2025.
//

import Foundation

enum UserDefaultsKeys {
    static let dailyGoal = "dailyGoal"
    static let currentIntake = "currentIntake"
    static let lastOpenedDate = "lastOpenedDate"
    static let lastIntakeDate = "lastIntakeDate"
    static let didScheduleNotifications = "didScheduleNotifications"
    static let cupSize = "cupSize"
    static let notificationsEnabled = "notificationsEnabled"
}

enum NotificationNames {
    static let didResetIntake = Notification.Name("didResetIntake")
    static let didUpdateDailyGoal = Notification.Name("didUpdateDailyGoal")
}

enum WaterDefaults {
    static let defaultGoal: Float = 2000
    static let defaultIncreaseAmount: Float = 250
}

enum ConstraintIdentifiers {
    static let progressHeight = "progressHeight"
}
