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
    
    var viewModel = WaterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnReset), name: .didResetIntake, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnGoalChange), name: .didUpdateDailyGoal, object: nil)
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
    }
    
    func updateUI(animated: Bool) {
        let progress = CGFloat(viewModel.progress)
        let intake = viewModel.waterData.currentIntake
        
        let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
        let newHeight = maxHeight * progress
        
        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == ConstraintIdentifiers.progressHeight}) {
            heightConstraint.constant = newHeight
        }
        
        goalBarHeightConstraint.constant = maxHeight
        
        percentageLabel.text = "\(Int(progress * 100))"
        mlLabel.text = "\(Int(intake))mL"
        goalMlLabel.text = "\(Int(viewModel.waterData.dailyGoal))mL"
        
        let updateBlock = {
            self.view.layoutIfNeeded()
            
            self.mlLabel.frame.origin.y = self.progressBarView.frame.origin.y - 20
        }
        
        animated ? UIView.animate(withDuration: 0.3, animations: updateBlock) : updateBlock()
    }
    
    func setupUI() {
        progressBarView.layer.cornerRadius = 5
        goalBarView.layer.cornerRadius = 5
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
