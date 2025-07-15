//
//  SettingsViewModel.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import UIKit
import Foundation
import UserDefaultsHelper

class SettingsViewModel {
    
    private let defaultGoal = 2000
    private let pickerStep = 250
    private let pickerMin = 1000
    private let pickerMax = 5000
    
    private let defaultCupSize = 250
    
    var pickerValues: [Int] {
        Array(stride(from: pickerMin, through: pickerMax, by: pickerStep))
    }
    
    var cupSizeValues: [Int] {
        return [100, 150, 200, 250, 300, 350, 400, 500]
    }
    
    var dailyGoal: Int {
        get {
            return UserDefaultsHelper.load(Int.self, forKey: UserDefaultsKeys.dailyGoal) ?? defaultGoal
        }
        set {
            UserDefaultsHelper.save(newValue, forKey: UserDefaultsKeys.dailyGoal)
        }
    }
    
    var cupSize: Int {
        get {
            return UserDefaultsHelper.load(Int.self, forKey: UserDefaultsKeys.cupSize) ?? defaultCupSize
        }
        set {
            UserDefaultsHelper.save(newValue, forKey: UserDefaultsKeys.cupSize)
        }
    }
    
    var notificationsEnabled: Bool {
        get {
            return UserDefaultsHelper.load(Bool.self, forKey: UserDefaultsKeys.notificationsEnabled) ?? false
        }
        set {
            UserDefaultsHelper.save(newValue, forKey: UserDefaultsKeys.notificationsEnabled)
            if newValue {
                NotificationManager.shared.requestPermission { granted in
                    if granted {
                        NotificationManager.shared.scheduleWaterRemindersIfNeeded()
                    } else {
                        DispatchQueue.main.async {
                            self.notificationsEnabled = false
                        }
                    }
                }
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UserDefaultsHelper.save(false, forKey: UserDefaultsKeys.didScheduleNotifications)
            }
        }
    }
    
    func resetProgress() {
        UserDefaultsHelper.save(0, forKey: UserDefaultsKeys.currentIntake)
        UserDefaultsHelper.remove(forKey: UserDefaultsKeys.lastIntakeDate)
        NotificationCenter.default.post(name: .didResetIntake, object: nil)
    }
    
    func updateDailyGoal(to newGoal: Int) {
        self.dailyGoal = newGoal
        resetProgress()
        NotificationCenter.default.post(name: .didUpdateDailyGoal, object: nil)
    }
}
