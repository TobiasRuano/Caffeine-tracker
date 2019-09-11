//
//  Secon.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 04/09/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController {
    @IBOutlet weak var logWaterView: UIView!
    @IBOutlet weak var unitsView: UIView!
    @IBOutlet weak var unitsSegment: UISegmentedControl!
    @IBOutlet weak var waterSwitch: UISwitch!
    var waterBoolean = true
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
        unitsView.layer.cornerRadius = 10
        unitsView.layer.shadowRadius = 10
        unitsView.layer.shadowColor = UIColor.lightGray.cgColor
        unitsView.layer.masksToBounds = false
        unitsView.layer.shadowOpacity = 0.5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(waterBoolean, forKey: logWaterBoolKey)
    }
    
    @IBAction func unitSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            unitGlobal = .ml
        case 1:
            unitGlobal = .flOzUS
        case 2:
            unitGlobal = .flOzUK
        default:
            unitGlobal = .ml
        }
        UserDefaults.standard.set(unitGlobal.rawValue, forKey: "Units")
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        waterBoolean = waterSwitch.isOn ? true : false
        UserDefaults.standard.set(waterBoolean, forKey: logWaterBoolKey)
    }
}
