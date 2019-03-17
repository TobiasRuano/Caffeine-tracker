//
//  OnboardingSingleHelpTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class OnboardingSingleHelpTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let cell = tableView.visibleCells[0] as! CTOnboardingCustomTableViewCell
        cell.showHint()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CTOnboardingCustomTableViewCell
        
        cell.cellTitle?.text = "Latte"
        cell.cellDescription?.text = "32mg"
        cell.cellimage?.image = UIImage(named: "Starbucks")
        return cell
    }

}
