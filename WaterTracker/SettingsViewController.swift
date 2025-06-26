//
//  SettingsViewController.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 25.06.2025.
//

import UIKit

class SettingsViewController: UIViewController {


    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func resetButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Progress", message: "Are you sure you want to reset your water progress?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            UserDefaults.standard.set(0, forKey: "currentIntake")
            NotificationCenter.default.post(name: Notification.Name("didResetIntake"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
