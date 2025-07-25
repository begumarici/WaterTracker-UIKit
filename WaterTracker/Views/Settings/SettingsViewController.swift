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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
        reloadSettings()
    }
    
    private func reloadSettings() {
        settings = [
            SettingItem(title: "Reset Water Intake", detail: nil, accessory: .none, action: { [weak self] in
                self?.showResetAlert()
            }),
            SettingItem(title: "Daily Goal", detail: "\(viewModel.dailyGoal)mL", accessory: .disclosureIndicator, action: { [weak self] in
                self?.showGoalPicker()
            }),
            SettingItem(title: "Cup Size", detail: "\(viewModel.cupSize)mL", accessory: .disclosureIndicator, action: { [weak self] in
                self?.showCupSizePicker()
            }),
            SettingItem(title: "Notifications", detail: "Receive daily reminders.", accessory: .none, action: nil)
        ]
        tableView.reloadData()
    }    

    func showResetAlert() {
        let alert = UIAlertController(title: "Reset Progress",
                                      message: "Are you sure you want to reset your water progress?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            self.viewModel.resetProgress()
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
            let selectedRow = picker.selectedRow(inComponent: 0)
            let newGoal = self.viewModel.pickerValues[selectedRow]
            self.viewModel.updateDailyGoal(to: newGoal)
            self.reloadSettings()
        }))

        present(alert, animated: true)
    }
    
    func showCupSizePicker() {
        let alert = UIAlertController(title: "Select Cup Size", message: "\n\n\n\n\n", preferredStyle: .alert)
        let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 1
        let selected = viewModel.cupSizeValues.firstIndex(of: viewModel.cupSize) ?? 0
        picker.selectRow(selected, inComponent: 0, animated: true)
        
        alert.view.addSubview(picker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            let newValue = self.viewModel.cupSizeValues[selectedRow]
            self.viewModel.cupSize = newValue
            self.reloadSettings()
        }))
        
        present(alert, animated: true)
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        
        self.title = "Settings"
        self.navigationItem.largeTitleDisplayMode = .always
    }
}
