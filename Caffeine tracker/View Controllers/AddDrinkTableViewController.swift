//
//  AddDrinkTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 15/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class AddDrinkTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var caffeineAmount: UITextField!
    
    @IBOutlet weak var iconCell: UITableViewCell!
    var iconName: String = "Starbucks"
    var drinkToAdd: drink = drink(type: "", caffeineML: 0, caffeineOZ: 0, icon: "Latte")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCell.imageView?.image = UIImage(named: iconName)
        
        tableView.keyboardDismissMode = .interactive
        UserDefaults.standard.set("Starbucks", forKey: "CellForCheckmark")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "CellForCheckmark") != nil {
            iconName = UserDefaults.standard.string(forKey: "CellForCheckmark")!
        }
        
        iconCell.imageView?.image = UIImage(named: iconName)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Hola")
        
        if let identifier = segue.identifier {
            if identifier == "unwind" {
                if name.text != "" && caffeineAmount.text != "" {
                    drinkToAdd.type = name.text!
                    print(name.text!)
                    drinkToAdd.caffeineML = Int(caffeineAmount.text!)!
                    drinkToAdd.caffeineOZ = Int(caffeineAmount.text!)!
                    drinkToAdd.icon = iconName
                    print(drinkToAdd)
                    
                    
                    //Taptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    self.dismiss(animated: true, completion: nil)
                }
            }else if identifier == "icon" {
                print("funca")
                let vc = segue.destination as! PickIconTableViewController
                if name.text != "" {
                    vc.objectName = name.text!
                }
                if caffeineAmount.text != "" {
                    vc.caffeine = "\(caffeineAmount.text!)mg"
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            self.view.endEditing(true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
