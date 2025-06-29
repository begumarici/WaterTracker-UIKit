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
    
    var pickerValues: [Int] {
        Array(stride(from: pickerMin, through: pickerMax, by: pickerStep))
    }
    
    var dailyGoal: Int {
        get {
            let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
            return goal == 0 ? 2000 : goal
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dailyGoal")
        }
    }
    
    func resetProgress() {
        UserDefaults.standard.set(0, forKey: "currentIntake")
        NotificationCenter.default.post(name: .init("didResetIntake"), object: nil)
    }
    
    func updateDailyGoal(to newGoal: Int) {
        self.dailyGoal = newGoal
        resetProgress()
        NotificationCenter.default.post(name: .init("didUpdateDailyGoal"), object: nil)
    }
    
    func generateSettingItems(resetAction: @escaping () -> Void, goalAction: @escaping () -> Void)-> [SettingItem] {
        return [
            SettingItem(title: "Reset Water Intake", detail: nil, accessory: .none, action: resetAction),
            SettingItem(title: "Daily Goal", detail: "\(dailyGoal)mL", accessory: .disclosureIndicator, action: goalAction)
        ]
    }
}
