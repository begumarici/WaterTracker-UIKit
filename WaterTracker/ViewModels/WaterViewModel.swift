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
    
    var progress: Float {
        return min(waterData.currentIntake / waterData.dailyGoal, 1.0)
    }
    
    init() {
        let goal = Float(UserDefaults.standard.integer(forKey: "dailyGoal") == 0 ? 2000 : UserDefaults.standard.integer(forKey: "dailyGoal"))
        let intake = UserDefaults.standard.float(forKey: "currentIntake")
        self.waterData = WaterData(currentIntake: intake, dailyGoal: goal)
    }
    
    func increaseIntake(by amount: Float = 250) {
        waterData.currentIntake = min(waterData.currentIntake + amount, waterData.dailyGoal)
        UserDefaults.standard.set(waterData.currentIntake, forKey: "currentIntake")
    }
    
    func resetIntake() {
        waterData.currentIntake = 0
        UserDefaults.standard.set(0, forKey: "currentIntake")
    }
    
    func updateGoal(_ newGoal: Float) {
        waterData.dailyGoal = newGoal
        UserDefaults.standard.set(newGoal, forKey: "dailyGoal")
    }
    
    func reloadData() {
        let goal = Float(UserDefaults.standard.integer(forKey: "dailyGoal") == 0 ? 2000 : UserDefaults.standard.integer(forKey: "dailyGoal"))
        let intake = UserDefaults.standard.float(forKey: "currentIntake")
        waterData = WaterData(currentIntake: intake, dailyGoal: goal)
    }
}
