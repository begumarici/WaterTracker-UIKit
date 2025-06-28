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
    @IBOutlet weak var dropButton: UIButton!
    
    var currentIntake: Float = 0
    var totalIntakeGoal: Float {
        return Float(UserDefaults.standard.integer(forKey: "dailyGoal") == 0 ? 2000 : UserDefaults.standard.integer(forKey: "dailyGoal"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.value(forKey: "dailyGoal") == nil {
            UserDefaults.standard.set(2000, forKey: "dailyGoal")
        }
        
        if let savedIntake = UserDefaults.standard.value(forKey: "currentIntake") as? Float {
            currentIntake = savedIntake
        }
        updateUI(animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReset), name: Notification.Name("didResetIntake"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDailyGoalUpdate), name: Notification.Name("didUpdateDailyGoal"), object: nil)
    }
    
    @objc func handleReset() {
        currentIntake = 0
        updateUI(animated: true)
    }
    
    @objc func handleDailyGoalUpdate() {
        updateUI(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI(animated: false)
    }
    
    @IBAction func dropButtonTapped(_ sender: Any) {
        let intakeStep: Float = 250
        
        if currentIntake < totalIntakeGoal {
            currentIntake += intakeStep
            if currentIntake > totalIntakeGoal {
                currentIntake = totalIntakeGoal
            }
            
            UserDefaults.standard.set(currentIntake, forKey: "currentIntake")
        }
        
        updateUI(animated: true)
       
    }
    
    func updateUI(animated: Bool) {
        let progress = CGFloat(currentIntake / totalIntakeGoal)
        
        
        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == "progressHeight" }) {
            let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
            heightConstraint.constant = maxHeight * progress
        }
        percentageLabel.text = "\(Int(progress * 100))"
        mlLabel.text = "\(Int(currentIntake))mL"
        
        let updateBlock = {
            self.view.layoutIfNeeded()
            self.mlLabel.translatesAutoresizingMaskIntoConstraints = true
            let progressBarY = self.progressBarView.frame.origin.y
            self.mlLabel.frame.origin.y = progressBarY - 20
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: updateBlock)
        } else {
            updateBlock()
        }
        
    }
}
