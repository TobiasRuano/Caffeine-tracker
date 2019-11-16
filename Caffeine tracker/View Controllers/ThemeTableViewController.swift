//
//  ThemeTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 20/09/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

//import UIKit
//
//class ThemeTableViewController: UITableViewController {
//    
//    @IBOutlet weak var systemModeSwitch: UISwitch!
//    var numberOfSections = 1
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        checkSystemModeSelection()
//        checkThemeMode()
//        
//        if #available(iOS 13, *) {} else {
//            systemModeSwitch.setOn(false, animated: false)
//            systemModeSwitch.isEnabled = false
//            UserDefaults.standard.set(false, forKey: systemModeKey)
//        }
//    }
//    
//    func checkThemeMode() {
//        if let value = UserDefaults.standard.value(forKey: themeKey) {
//            let status = value as! Bool
//            if status == false {
//                tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .checkmark
//            } else {
//                tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .checkmark
//            }
//        }
//    }
//    
//    func checkSystemModeSelection() {
//        if let value = UserDefaults.standard.value(forKey: systemModeKey) {
//            let status = value as! Bool
//            if status == true {
//                numberOfSections = 1
//                systemModeSwitch.setOn(true, animated: false)
//            } else {
//                numberOfSections = 2
//                systemModeSwitch.setOn(false, animated: false)
//            }
//            tableView.reloadData()
//        }
//    }
//    
//    @IBAction func changeMode(_ sender: UISwitch) {
//        if systemModeSwitch.isOn {
//            numberOfSections = 1
//            UserDefaults.standard.set(true, forKey: systemModeKey)
//            if #available(iOS 13.0, *) {
//                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .unspecified
//            }
//            tableView.reloadData()
//        } else {
//            numberOfSections = 2
//            UserDefaults.standard.set(false, forKey: systemModeKey)
//            tableView.reloadData()
//        }
//    }
//    
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return numberOfSections
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == 1 && indexPath.row == 0 {
//            UserDefaults.standard.set(false, forKey: themeKey)
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .none
//            if #available(iOS 13.0, *) {
//                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
//            } else {
//                // Post the notification to let all current view controllers that the app has changed to non-dark mode, and they should theme themselves to reflect this change.
//                NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
//            }
//        } else if indexPath.section == 1 && indexPath.row == 1 {
//            UserDefaults.standard.set(true, forKey: themeKey)
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .none
//            if #available(iOS 13.0, *) {
//                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
//            } else {
//                // Post the notification to let all current view controllers that the app has changed to dark mode, and they should theme themselves to reflect this change.
//                NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
//            }
//        }
//    }
//}
