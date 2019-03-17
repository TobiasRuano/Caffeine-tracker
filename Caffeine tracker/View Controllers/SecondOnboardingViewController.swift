//
//  SecondOnboardingViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "OnboardingScreen")
        performSegue(withIdentifier: "ExitOnboarding", sender: self)
    }
}
