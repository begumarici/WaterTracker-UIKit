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
    
    init() {
        let goal = Float(UserDefaults.standard.integer(forKey: UserDefaultsKeys.dailyGoal))
        let intake = UserDefaults.standard.float(forKey: UserDefaultsKeys.currentIntake)
        self.waterData = WaterData(currentIntake: intake, dailyGoal: goal == 0 ? defaultGoal : goal)
    }
    
    func increaseIntake(by amount: Float = 250) {
        waterData.currentIntake = min(waterData.currentIntake + amount, waterData.dailyGoal)
        UserDefaults.standard.set(waterData.currentIntake, forKey: UserDefaultsKeys.currentIntake)
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
