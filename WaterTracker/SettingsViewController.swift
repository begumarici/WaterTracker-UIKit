//
//  SettingsViewController.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 25.06.2025.
//

import UIKit

struct SettingItem {
    let title: String
    let detail: String?
    let accessory: UITableViewCell.AccessoryType
    let action: (() -> Void)?
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal") == 0 ? 2000 : UserDefaults.standard.integer(forKey: "dailyGoal")
    var settings: [SettingItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white

        let resetItem = SettingItem(
            title: "Reset Water Intake",
            detail: nil,
            accessory: .none,
            action: { [weak self] in self?.showResetAlert() }
        )

        let goalItem = SettingItem(
            title: "Daily Goal",
            detail: "\(dailyGoal) ml",
            accessory: .disclosureIndicator,
            action: { [weak self] in self?.showGoalPicker() }
        )

        settings = [resetItem, goalItem]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        let item = settings[indexPath.row]
        cell.backgroundColor = .white
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = .darkGray
        cell.accessoryType = item.accessory
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].action?()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func showResetAlert() {
        let alert = UIAlertController(title: "Reset Progress",
                                      message: "Are you sure you want to reset your water progress?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            UserDefaults.standard.set(0, forKey: "currentIntake")
            NotificationCenter.default.post(name: Notification.Name("didResetIntake"), object: nil)
        }))
        present(alert, animated: true)
    }

    func showGoalPicker() {
        let warning = UIAlertController(
            title: "Change Daily Goal",
            message: "Changing your daily goal will reset your current progress. Do you want to continue?",
            preferredStyle: .alert
        )

        warning.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        warning.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
            self.presentGoalPicker()
        }))

        present(warning, animated: true)
    }
    
    func presentGoalPicker() {
        let alert = UIAlertController(title: "Set Daily Goal", message: "\n\n\n\n\n", preferredStyle: .alert)

        let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(pickerValues.firstIndex(of: dailyGoal) ?? 0, inComponent: 0, animated: false)
        alert.view.addSubview(picker)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { _ in

            self.dailyGoal = self.pickerValues[self.selectedPickerRow]
            UserDefaults.standard.set(self.dailyGoal, forKey: "dailyGoal")

            UserDefaults.standard.set(0, forKey: "currentIntake")
            NotificationCenter.default.post(name: Notification.Name("didResetIntake"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("didUpdateDailyGoal"), object: nil)

            self.settings = [
                SettingItem(
                    title: "Reset Water Intake",
                    detail: nil,
                    accessory: .none,
                    action: { [weak self] in self?.showResetAlert() }
                ),
                SettingItem(
                    title: "Daily Goal",
                    detail: "\(self.dailyGoal) ml",
                    accessory: .disclosureIndicator,
                    action: { [weak self] in self?.showGoalPicker() }
                )
            ]
            self.tableView.reloadData()
        }))

        present(alert, animated: true)
    }

    let pickerValues = Array(stride(from: 1000, through: 5000, by: 250))
    var selectedPickerRow = 0
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerValues[row]) ml"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerRow = row
    }
}
