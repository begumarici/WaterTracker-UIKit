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
        cell.backgroundColor = .white
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = .darkGray
        cell.textLabel?.textColor = .black
        cell.accessoryType = item.accessory
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].action?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
