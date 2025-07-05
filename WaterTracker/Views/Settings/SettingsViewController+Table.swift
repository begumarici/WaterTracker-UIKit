//
//  SettingsViewController+Table.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 29.06.2025.
//

import UIKit

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        configure(cell: cell, with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].action?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configure(cell: UITableViewCell, with item: SettingItem) {
        cell.backgroundColor = .white
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.textLabel?.font = AppFont.semiBold(17)
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.font = AppFont.light(15)
        cell.detailTextLabel?.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        cell.accessoryType = item.accessory
    }
}
