//
//  NotificationManager.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 5.07.2025.
//

import Foundation
import UserNotifications
import UserDefaultsHelper

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    private let waterMessages = [
        "Time to drink water and refresh your mind! 💧",
        "Stay hydrated, stay focused! 🧠",
        "A glass of water can do wonders - drink up! ✨",
        "Water is life - take a sip! 🌱",
        "Feeling tired? Maybe your body needs water. 🚰"
    ]
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    func scheduleWaterRemindersIfNeeded() {
        let hasScheduled = UserDefaultsHelper.load(Bool.self, forKey: UserDefaultsKeys.didScheduleNotifications) ?? false
        
        guard !hasScheduled else { return }
        
        let hours = [10, 13, 16]
        
        for (index, hour) in hours.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Water Tracker"
            content.body = waterMessages[index % waterMessages.count]
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "water_\(hour)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        UserDefaultsHelper.save(true, forKey: UserDefaultsKeys.didScheduleNotifications)
    }
}
