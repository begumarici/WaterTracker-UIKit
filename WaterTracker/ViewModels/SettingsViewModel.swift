//
//  SettingsViewModel.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import UIKit
import Foundation

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
            let goal = UserDefaults.standard.integer(forKey: UserDefaultsKeys.dailyGoal)
            return goal == 0 ? defaultGoal : goal
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.dailyGoal)
        }
    }
    
    var cupSize: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: UserDefaultsKeys.cupSize)
            return value == 0 ? defaultCupSize : value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.cupSize)
        }
    }
    
    func resetProgress() {
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.currentIntake)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.lastIntakeDate)
        NotificationCenter.default.post(name: .didResetIntake, object: nil)
    }
    
    func updateDailyGoal(to newGoal: Int) {
        self.dailyGoal = newGoal
        resetProgress()
        NotificationCenter.default.post(name: .didUpdateDailyGoal, object: nil)
    }
    
    func generateSettingItems(resetAction: @escaping () -> Void,
                              goalAction: @escaping () -> Void,
                              cupSizeAction: @escaping ()-> Void ) -> [SettingItem] {
        return [
            SettingItem(title: "Reset Water Intake", detail: nil, accessory: .none, action: resetAction),
            SettingItem(title: "Daily Goal", detail: "\(dailyGoal)mL", accessory: .disclosureIndicator, action: goalAction),
            SettingItem(title: "Cup Size", detail: "\(cupSize)mL", accessory: .disclosureIndicator, action: cupSizeAction)
        ]
    }
}
