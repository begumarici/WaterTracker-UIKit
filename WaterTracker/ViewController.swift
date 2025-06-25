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
    let totalIntakeGoal: Float = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == "progressHeight" }) {
 
            let progress = CGFloat(currentIntake / totalIntakeGoal)
            let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
            heightConstraint.constant = maxHeight * progress
            }
    }
    
    @IBAction func dropButtonTapped(_ sender: Any) {
        let intakeStep: Float = 250

        if currentIntake < totalIntakeGoal {
            currentIntake += intakeStep
            if currentIntake > totalIntakeGoal {
                currentIntake = totalIntakeGoal
            }
        }

        let progress = CGFloat(currentIntake / totalIntakeGoal)

        if let heightConstraint = progressBarView.constraints.first(where: { $0.identifier == "progressHeight" }) {
            let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 40
            let newHeight = maxHeight * progress
            heightConstraint.constant = newHeight

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()

                self.mlLabel.translatesAutoresizingMaskIntoConstraints = true
                let progressBarY = self.progressBarView.frame.origin.y
                let newY = progressBarY - 20
                self.mlLabel.frame.origin.y = newY
            }
        }

        percentageLabel.text = "\(Int(progress * 100))"
        mlLabel.text = "\(Int(currentIntake))mL"
    }

}
