//
//  HomeViewModel.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import Foundation
import UIKit
import UserDefaultsHelper

class WaterViewModel {
    
    private(set) var waterData: WaterData
    
    private let defaultGoal: Float = 2000
    private let defaultIntake: Float = 0
    
    private var cupSize: Float {
        let stored = UserDefaultsHelper.load(Int.self, forKey: UserDefaultsKeys.cupSize) ?? 250
        return Float(stored)
    }
    
    var progress: Float {
        return min(waterData.currentIntake / waterData.dailyGoal, 1.0)
    }

    var lastIntakeDate: Date? {
        UserDefaultsHelper.load(Date.self, forKey: UserDefaultsKeys.lastIntakeDate)
    }
    
    init() {
        Self.resetIfNewDay()
        
        let goal = Float(UserDefaultsHelper.load(Int.self, forKey: UserDefaultsKeys.dailyGoal) ?? Int(defaultGoal))
        let intake = UserDefaultsHelper.load(Float.self, forKey: UserDefaultsKeys.currentIntake) ?? defaultIntake
        self.waterData = WaterData(currentIntake: intake, dailyGoal: goal)
    }
    
    private static func resetIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = UserDefaultsHelper.load(Date.self, forKey: UserDefaultsKeys.lastOpenedDate) {
            let lastOpenedDay = Calendar.current.startOfDay(for: lastDate)
            if lastOpenedDay != today {
                UserDefaultsHelper.save(0.0, forKey: UserDefaultsKeys.currentIntake)
                NotificationCenter.default.post(name: .didResetIntake, object: nil)
                UserDefaultsHelper.remove(forKey: UserDefaultsKeys.lastIntakeDate)
            }
        }
        UserDefaultsHelper.save(Date(), forKey: UserDefaultsKeys.lastOpenedDate)
    }
    
    func increaseIntake(by amount: Float? = nil) {
        if waterData.currentIntake >= waterData.dailyGoal { return }

        let intakeAmount = amount ?? cupSize
        let newIntake = min(waterData.currentIntake + intakeAmount, waterData.dailyGoal)

        if newIntake > waterData.currentIntake {
            waterData.currentIntake = newIntake
            UserDefaultsHelper.save(waterData.currentIntake, forKey: UserDefaultsKeys.currentIntake)
            UserDefaultsHelper.save(Date(), forKey: UserDefaultsKeys.lastIntakeDate)
        }
    }
    
    func decreaseIntake(by amount: Float? = nil) {
        let intakeAmount = amount ?? cupSize
        if waterData.currentIntake - intakeAmount < 0 { return }

        let newIntake = min(waterData.currentIntake - intakeAmount, waterData.dailyGoal)
        if newIntake < waterData.currentIntake {
            waterData.currentIntake = newIntake
            UserDefaultsHelper.save(waterData.currentIntake, forKey: UserDefaultsKeys.currentIntake)
        }
    }
    
    func resetIntake() {
        waterData.currentIntake = defaultIntake
        UserDefaultsHelper.save(defaultIntake, forKey: UserDefaultsKeys.currentIntake)
    }
    
    func updateGoal(_ newGoal: Float) {
        waterData.dailyGoal = newGoal
        UserDefaultsHelper.save(newGoal, forKey: UserDefaultsKeys.dailyGoal)
    }
    
    func reloadData() {
        let goal = Float(UserDefaultsHelper.load(Int.self, forKey: UserDefaultsKeys.dailyGoal) ?? Int(defaultGoal))
        let intake = UserDefaultsHelper.load(Float.self, forKey: UserDefaultsKeys.currentIntake) ?? defaultIntake
        waterData = WaterData(currentIntake: intake, dailyGoal: goal)
    }
}
