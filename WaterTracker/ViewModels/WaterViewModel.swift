//
//  HomeViewModel.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import Foundation
import UIKit

class WaterViewModel {
    
    private(set) var waterData: WaterData
    
    private let defaultGoal: Float = 2000
    private let defaultIntake: Float = 0
    private let defaultIntakeStep: Float = 250
    
    var progress: Float {
        return min(waterData.currentIntake / waterData.dailyGoal, 1.0)
    }
    var lastIntakeDate: Date? {
        UserDefaults.standard.object(forKey: UserDefaultsKeys.lastIntakeDate) as? Date
    }
    
    init() {
        Self.resetIfNewDay()
        
        let goal = Float(UserDefaults.standard.integer(forKey: UserDefaultsKeys.dailyGoal))
        let intake = UserDefaults.standard.float(forKey: UserDefaultsKeys.currentIntake)
        self.waterData = WaterData(currentIntake: intake, dailyGoal: goal == 0 ? defaultGoal : goal)
    }
    
    private static func resetIfNewDay() {
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastOpenedDate) as? Date {
            let lastOpenedDay = Calendar.current.startOfDay(for: lastDate)
            if lastOpenedDay != today {
                UserDefaults.standard.set(0.0, forKey: UserDefaultsKeys.currentIntake)
                NotificationCenter.default.post(name: .didResetIntake, object: nil)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.lastIntakeDate)
            }
        }
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastOpenedDate)
        
    }
    func increaseIntake(by amount: Float = 250) {
        if waterData.currentIntake >= waterData.dailyGoal {
            return
        }

        let newIntake = min(waterData.currentIntake + amount, waterData.dailyGoal)
        
        if newIntake > waterData.currentIntake {
            waterData.currentIntake = newIntake
            UserDefaults.standard.set(waterData.currentIntake, forKey: UserDefaultsKeys.currentIntake)
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastIntakeDate)
        }
    }
    
    func resetIntake() {
        waterData.currentIntake = defaultIntake
        UserDefaults.standard.set(defaultIntake, forKey: UserDefaultsKeys.currentIntake)
    }
    
    func updateGoal(_ newGoal: Float) {
        waterData.dailyGoal = newGoal
        UserDefaults.standard.set(newGoal, forKey: UserDefaultsKeys.dailyGoal)
    }
    
    func reloadData() {
        let goal = Float(UserDefaults.standard.integer(forKey: UserDefaultsKeys.dailyGoal))
        let intake = UserDefaults.standard.float(forKey: UserDefaultsKeys.currentIntake)
        waterData = WaterData(currentIntake: intake, dailyGoal: goal == 0 ? defaultGoal : goal)
    }
}
