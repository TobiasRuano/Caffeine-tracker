//
//  SecondOnboardingViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class ThirdOnboardingViewController: UIViewController {

    @IBOutlet weak var logWaterView: UIView!
    @IBOutlet weak var waterSwitch: UISwitch!
//    var waterBoolean = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogWaterView()
    }
    
    func styleLogWaterView() {
        logWaterView.layer.cornerRadius = 10
        logWaterView.layer.shadowRadius = 10
        logWaterView.layer.shadowColor = UIColor.lightGray.cgColor
        logWaterView.layer.masksToBounds = false
        logWaterView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
//        waterBoolean = waterSwitch.isOn ? true : false
    }
    
    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "OnboardingScreen")
//        UserDefaults.standard.set(waterBoolean, forKey: logWaterBoolKey)
        self.dismiss(animated: true, completion: nil)
    }
}
