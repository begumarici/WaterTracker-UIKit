//
//  SettingItem.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import UIKit

struct SettingItem {
    let title: String
    let detail: String?
    let accessory: UITableViewCell.AccessoryType
    let action: (() -> Void)?
}
