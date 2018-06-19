//
//  PickIconTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 16/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

var prueba: String = "Starbucks"

class PickIconTableViewController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    @IBOutlet weak var cell7: UITableViewCell!
    
    var objectName: String = "Latte"
    var caffeine: String = "100mg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "CellForCheckmark") != nil {
            prueba = UserDefaults.standard.string(forKey: "CellForCheckmark")!
        }
        
        if prueba == "Starbucks" {
            checkMark(activeCell: cell1, inActiveCell1: cell2, inActiveCell2: cell3, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7)
        }else if prueba == "BottleWater" {
            checkMark(activeCell: cell2, inActiveCell1: cell1, inActiveCell2: cell3, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7)
        }else if prueba == "Coffee" {
            checkMark(activeCell: cell3, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell4, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7)
        }else if prueba == "Can" {
            checkMark(activeCell: cell4, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell5, inActiveCell5: cell6, inActiveCell6: cell7)
        }else if prueba == "milkshake" {
            checkMark(activeCell: cell5, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell6, inActiveCell6: cell7)
        }else if prueba == "Cafe" {
            checkMark(activeCell: cell6, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell5, inActiveCell6: cell7)
        }else if prueba == "cafe3" {
            checkMark(activeCell: cell7, inActiveCell1: cell1, inActiveCell2: cell2, inActiveCell3: cell3, inActiveCell4: cell4, inActiveCell5: cell5, inActiveCell6: cell6)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell1!, inActiveCell1: cell2!, inActiveCell2: cell3!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!)
            prueba = "Starbucks"
            saveChoice(texto: prueba)
            
        }else if indexPath.section == 0 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell2!, inActiveCell1: cell1!, inActiveCell2: cell3!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!)
            prueba = "BottleWater"
            saveChoice(texto: prueba)
            
        }else if indexPath.section == 0 && indexPath.row == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell3!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell4!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!)
            prueba = "Coffee"
            saveChoice(texto: prueba)
            
        }else if indexPath.section == 0 && indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell4!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell5!, inActiveCell5: cell6!, inActiveCell6: cell7!)
            prueba = "Can"
            saveChoice(texto: prueba)
            
        }else if indexPath.section == 0 && indexPath.row == 4 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell5!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell6!, inActiveCell6: cell7!)
            prueba = "milkshake"
            saveChoice(texto: prueba)
        }else if indexPath.section == 0 && indexPath.row == 5 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell6!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell7!)
            prueba = "Cafe"
            saveChoice(texto: prueba)
        }else if indexPath.section == 0 && indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            checkMark(activeCell: cell7!, inActiveCell1: cell1!, inActiveCell2: cell2!, inActiveCell3: cell3!, inActiveCell4: cell4!, inActiveCell5: cell5!, inActiveCell6: cell6!)
            prueba = "cafe3"
            saveChoice(texto: prueba)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = objectName
        cell.detailTextLabel?.text = String(caffeine)
        
        return cell
    }
    
    // MARK: Other Functions
    func checkMark(activeCell: UITableViewCell, inActiveCell1: UITableViewCell, inActiveCell2: UITableViewCell, inActiveCell3: UITableViewCell, inActiveCell4: UITableViewCell, inActiveCell5: UITableViewCell, inActiveCell6: UITableViewCell) {
        activeCell.accessoryType = .checkmark
        inActiveCell1.accessoryType = .none
        inActiveCell2.accessoryType = .none
        inActiveCell3.accessoryType = .none
        inActiveCell4.accessoryType = .none
        inActiveCell5.accessoryType = .none
        inActiveCell6.accessoryType = .none
    }
    
    func saveChoice(texto: String) {
        UserDefaults.standard.set(texto, forKey: "CellForCheckmark")
    }
    
    
    /*
    // MARK: - Navigation
    */
}
