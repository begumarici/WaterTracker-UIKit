//
//  SettingsViewController.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 25.06.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var settings: [SettingItem] = []
    var viewModel = SettingsViewModel()
    var selectedPickerRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white

        reloadSettings()
    }
    
    private func reloadSettings() {
        settings = viewModel.generateSettingItems(
            resetAction: {[weak self] in self?.showResetAlert() },
            goalAction: { [weak self] in self?.showGoalPicker() }
        )
        tableView.reloadData()
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
    
    private func presentGoalPicker() {
        let alert = UIAlertController(title: "Set Daily Goal", message: "\n\n\n\n\n", preferredStyle: .alert)
        let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(viewModel.pickerValues.firstIndex(of: viewModel.dailyGoal) ?? 0, inComponent: 0, animated: false)
        alert.view.addSubview(picker)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { _ in
            let newGoal = self.viewModel.pickerValues[self.selectedPickerRow]
            self.viewModel.updateDailyGoal(to: newGoal)
            self.reloadSettings()
        }))

        present(alert, animated: true)
    }

}
