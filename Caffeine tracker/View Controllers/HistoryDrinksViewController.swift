//
//  RecentsDrinksViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 14/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class HistoryDrinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var yesterdayCaffeine: UILabel!
    @IBOutlet weak var lastWeekCaffeine: UILabel!
    @IBOutlet weak var tablewView: UITableView!
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tablewView.reloadData()
        
        progressViewStyle()
        progress.progress = 0.4
        
        tablewView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey: arrayDrinksAddedKey) as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
        }
        
        yesterdayCaffeine.text = "mg"
        lastWeekCaffeine.text = "mg"
        
        tablewView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caffeine"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = UserDefaults.standard.value(forKey: arrayDrinksAddedKey) as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
        }
        return arrayDrinksAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyTableViewCell, for: indexPath)
        
        cell.textLabel?.text = arrayDrinksAdded.reversed()[indexPath.row].type
        cell.detailTextLabel?.text = "\(String(arrayDrinksAdded.reversed()[indexPath.row].caffeineML))mg"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(arrayDrinksAdded.reversed()[indexPath.row].caffeineML)mg of \(arrayDrinksAdded.reversed()[indexPath.row].type)?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                let indice = (arrayDrinksAdded.count - (indexPath.row + 1))
                arrayDrinksAdded.remove(at: indice);
                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: arrayDrinksAddedKey)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                //Taptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Cancel button")
            }))
            
            self.present(alert, animated: true, completion: {
                print("ActionSheet action completed!")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func progressViewStyle() {
        // Progress View Style
        let gradientView = GradientView(frame: progress.bounds)
        //convert gradient view to image , flip horizontally and assign as the track image
        progress.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        //invert the progress view
        progress.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        progress.progressTintColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        progress.progress = 1
        progress.layer.cornerRadius = 8.0
        progress.layer.shadowColor = UIColor.lightGray.cgColor
        progress.layer.shadowOpacity = 1
        progress.layer.shadowOffset = CGSize.zero
        progress.layer.shadowRadius = 5
        self.progress.clipsToBounds = true
    }
}

extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}
