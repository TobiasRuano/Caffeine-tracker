//
//  PickIconTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 16/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class PickIconTableViewController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    @IBOutlet weak var cell7: UITableViewCell!
    @IBOutlet weak var cell8: UITableViewCell!
    
    var objectName: String = "Latte"
    var caffeine: String = "100mg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActiveTableViewCheckmark()
    }
    
    // MARK: Other Functions
    func checkMark(activeCell: UITableViewCell, inActiveCell1: UITableViewCell, inActiveCell2: UITableViewCell, inActiveCell3: UITableViewCell, inActiveCell4: UITableViewCell, inActiveCell5: UITableViewCell, inActiveCell6: UITableViewCell, inActiveCell7: UITableViewCell) {
        activeCell.accessoryType = .checkmark
        inActiveCell1.accessoryType = .none
        inActiveCell2.accessoryType = .none
        inActiveCell3.accessoryType = .none
        inActiveCell4.accessoryType = .none
        inActiveCell5.accessoryType = .none
        inActiveCell6.accessoryType = .none
        inActiveCell7.accessoryType = .none
    }
    
    func saveChoice(texto: String) {
        UserDefaults.standard.set(texto, forKey: cellForCheckmarkKey)
    }
    
    func setActiveTableViewCheckmark() {
        if UserDefaults.standard.string(forKey: cellForCheckmarkKey) != nil {
            checkMarkString = UserDefaults.standard.string(forKey: cellForCheckmarkKey)!
        }
        switch checkMarkString {
        case "Starbucks":
            checkMark(activeCell: cell1, inActiveCell1: cell2, inActiveCell2: cell3, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "Coffee":
            checkMark(activeCell: cell2, inActiveCell1: cell1, inActiveCell2: cell3, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "Cafe":
            checkMark(activeCell: cell3, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "cafe3":
            checkMark(activeCell: cell4, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "TeaCup":
            checkMark(activeCell: cell5, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell6, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "BottleWater":
            checkMark(activeCell: cell6, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell5, inActiveCell6: cell7, inActiveCell7: cell8!)
        case "Can":
            checkMark(activeCell: cell7, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell5, inActiveCell6: cell6, inActiveCell7: cell8!)
        case "milkshake":
            checkMark(activeCell: cell8!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell6!, inActiveCell7: cell7!)
        default: break
            
        }
    }

    // ----
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            checkMark(activeCell: cell1!, inActiveCell1: cell2!, inActiveCell2: cell3!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "Starbucks"
        case 1:
            checkMark(activeCell: cell2!, inActiveCell1: cell1!, inActiveCell2: cell3!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "Coffee"
        case 2:
            checkMark(activeCell: cell3!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "Cafe"
        case 3:
            checkMark(activeCell: cell4!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "cafe3"
        case 4:
            checkMark(activeCell: cell5!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell6!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "TeaCup"
        case 5:
            checkMark(activeCell: cell6!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell7!, inActiveCell7: cell8!)
            checkMarkString = "BottleWater"
        case 6:
            checkMark(activeCell: cell7!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell6!, inActiveCell7: cell8!)
            checkMarkString = "Can"
        case 7:
            checkMark(activeCell: cell8!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell6!, inActiveCell7: cell7!)
            checkMarkString = "milkshake"
        default: break
        }
        saveChoice(texto: checkMarkString)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = objectName
        cell.detailTextLabel?.text = "\(String(caffeine)) of caffeine in 100ml"
        return cell
    }
}
