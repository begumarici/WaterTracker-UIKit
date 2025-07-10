//
//  ViewController.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 24.06.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var mlLabel: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var goalBarView: UIView!
    @IBOutlet weak var goalBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var goalMlLabel: UILabel!
    @IBOutlet weak var lastIntakeLabel: UILabel!
    @IBOutlet weak var percentageSymbolLabel: UILabel!
    @IBOutlet weak var waveView: WaveView!
    @IBOutlet weak var waveViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel = WaterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnReset), name: .didResetIntake, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnGoalChange), name: .didUpdateDailyGoal, object: nil)
        
        NotificationManager.shared.requestPermission { granted in
                if granted {
                    NotificationManager.shared.scheduleWaterRemindersIfNeeded()
                } else {
                    print("Notification permission not granted.")
                }
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI(animated: false)
    }
    
    @objc func updateOnReset() {
        viewModel.resetIntake()
        updateUI(animated: true)
    }
    
    @objc func updateOnGoalChange() {
        viewModel.reloadData()
        updateUI(animated: true)
    }
    
    @IBAction func waterButtonTapped(_ sender: Any) {
        viewModel.increaseIntake()
        updateUI(animated: true)
        waveView.boostWaveSpeedTemporarily()
    }
    
    func updateUI(animated: Bool) {
        let progress = CGFloat(viewModel.progress)
        let intake = viewModel.waterData.currentIntake
        
        let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
        let newHeight = maxHeight * progress
        
        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == ConstraintIdentifiers.progressHeight}) {
            heightConstraint.constant = newHeight
        }
        
        waveViewHeightConstraint.constant = newHeight
        goalBarHeightConstraint.constant = maxHeight
        
        percentageLabel.text = "\(Int(progress * 100))"
        mlLabel.text = "\(Int(intake))mL"
        goalMlLabel.text = "\(Int(viewModel.waterData.dailyGoal))mL"
        
        if let date = viewModel.lastIntakeDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "HH:mm"
            lastIntakeLabel.text = "Last intake: \(formatter.string(from: date))"
        } else {
            lastIntakeLabel.text = "you haven't drunk any water today."
        }
        
        let updateBlock = {
            self.view.layoutIfNeeded()
            
            self.mlLabel.frame.origin.y = self.progressBarView.frame.origin.y - 20
        }
        
        animated ? UIView.animate(withDuration: 0.3, animations: updateBlock) : updateBlock()
    }
    
    func setupUI() {
        self.title = "Water Tracker"
        self.navigationItem.largeTitleDisplayMode = .always
        
        progressBarView.layer.cornerRadius = 5
        goalBarView.layer.cornerRadius = 5
        
        mlLabel.font = AppFont.bold(17)
        goalMlLabel.font = AppFont.bold(17)

        percentageLabel.font = AppFont.black(100)
        percentageSymbolLabel.font = AppFont.extraBold(30)

        lastIntakeLabel.font = AppFont.extraBold(17)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
