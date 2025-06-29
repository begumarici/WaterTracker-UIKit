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
    
    var viewModel = WaterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnReset), name: .init("didResetIntake"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnGoalChange), name: .init("didUpdateDailyGoal"), object: nil)
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
        
        // height
        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == "progressHeight"}) {
            let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
            heightConstraint.constant = maxHeight * progress
        }
        
        percentageLabel.text = "\(Int(progress * 100))"
        mlLabel.text = "\(Int(intake))mL"
        
        let updateBlock = {
            self.view.layoutIfNeeded()
            self.mlLabel.translatesAutoresizingMaskIntoConstraints = true
            self.mlLabel.frame.origin.y = self.progressBarView.frame.origin.y - 20
        }
        
        animated ? UIView.animate(withDuration: 0.3, animations: updateBlock) : updateBlock()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
