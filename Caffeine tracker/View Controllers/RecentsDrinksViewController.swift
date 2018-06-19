//
//  RecentsDrinksViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 14/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class RecentsDrinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var yesterdayCaffeine: UILabel!
    @IBOutlet weak var lastWeekCaffeine: UILabel!
    @IBOutlet weak var thisMonthCaffeine: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caffeine"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = UserDefaults.standard.value(forKey:"arrayAdded") as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
        }
        return arrayDrinksAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = arrayDrinksAdded.reversed()[indexPath.row].type
        cell.detailTextLabel?.text = "\(String(arrayDrinksAdded.reversed()[indexPath.row].caffeineML))mg"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alertController = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this Log?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
                
                arrayDrinksAdded.remove(at: indexPath.row);
                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: "arrayAdded")
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                //Taptic feedback meterlo en la funcion alert
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey:"arrayAdded") as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
        }
        
        yesterdayCaffeine.text = "mg"
        lastWeekCaffeine.text = "mg"
        thisMonthCaffeine.text = "mg"
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
