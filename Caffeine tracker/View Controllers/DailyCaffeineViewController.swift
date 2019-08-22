//
//  DailyCaffeineViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 22/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class DailyCaffeineViewController: UITableViewController {

    @IBOutlet weak var CaffeineTextLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "maxCaf") != nil {
            let number = UserDefaults.standard.value(forKey: "maxCaf") as! Int
            CaffeineTextLabel.placeholder = "\(number)mg"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if CaffeineTextLabel.text != "" && checkValidNumber() == true {
            let number = Int(CaffeineTextLabel!.text!)
            UserDefaults.standard.set(number, forKey: "maxCaf")
        }
    }
    
    func checkValidNumber() -> Bool {
        if let _ = Int(CaffeineTextLabel!.text!) {
            return true
        } else {
            return false
        }
    }
}
