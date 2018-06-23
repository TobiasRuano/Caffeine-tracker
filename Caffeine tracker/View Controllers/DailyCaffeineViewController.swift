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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "maxCaf") != nil {
            CaffeineTextLabel.placeholder = "\(UserDefaults.standard.value(forKey: "maxCaf") as! String)mg"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if CaffeineTextLabel.text != "" {
            UserDefaults.standard.set(CaffeineTextLabel.text, forKey: "maxCaf")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
