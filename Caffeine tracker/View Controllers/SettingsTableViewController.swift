//
//  SettingsTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet var maxDailyCaf: UILabel!
    @IBOutlet weak var waterLogSwitch: UISwitch!
    @IBOutlet weak var mlCell: UITableViewCell!
    @IBOutlet weak var usOzCell: UITableViewCell!
    @IBOutlet weak var ukOzCell: UITableViewCell!
    var logWater: Bool = false
    var unitML: Bool = true
    var healthStatus: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logWater = UserDefaults.standard.value(forKey: logWaterBoolKey) as! Bool
        if logWater == true {
            waterLogSwitch.isOn = true
        }else {
            waterLogSwitch.isOn = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.value(forKey: healthStatusKey) {
            healthStatus = value as! Bool
            print(healthStatus)
            if healthStatus {
                healthLabel.text = "Enabled"
            } else {
                healthLabel.text = "Disabled"
            }
        }
        if UserDefaults.standard.value(forKey: "maxCaf") != nil {
            let value = UserDefaults.standard.value(forKey: "maxCaf") as! Int
            maxDailyCaf.text = "\(value)mg"
        }else {
            maxDailyCaf.text = "400mg"
        }
        switch unitGlobal {
        case .ml:
            mlCell.accessoryType = .checkmark
            usOzCell.accessoryType = .none
            ukOzCell.accessoryType = .none
        case .flOzUS:
            mlCell.accessoryType = .none
            usOzCell.accessoryType = .checkmark
            ukOzCell.accessoryType = .none
        case .flOzUK:
            mlCell.accessoryType = .none
            usOzCell.accessoryType = .none
            ukOzCell.accessoryType = .checkmark
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    unitGlobal = .ml
                    //UserDefaults.standard.set(try? PropertyListEncoder().encode(unitGlobal), forKey: "Units")
                    UserDefaults.standard.set(unitGlobal.rawValue, forKey: "Units")
                    //UserDefaults.standard.set(unitGlobal, forKey: "Unitsb")
                    let cell2 = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))
                    let cell3 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 1))
                    cell2?.accessoryType = .none
                    cell3?.accessoryType = .none
                }
            }
        } else if indexPath.section == 1 && indexPath.row == 1 {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    unitGlobal = .flOzUS
                    //UserDefaults.standard.set(unitGlobal, forKey: "Units")
                    //UserDefaults.standard.set(try? PropertyListEncoder().encode(unitGlobal), forKey: "Units")
                    UserDefaults.standard.set(unitGlobal.rawValue, forKey: "Units")
                    let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))
                    let cell3 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 1))
                    cell2?.accessoryType = .none
                    cell3?.accessoryType = .none
                }
            }
        } else if indexPath.section == 1 && indexPath.row == 2 {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    unitGlobal = .flOzUK
                    //UserDefaults.standard.set(try? PropertyListEncoder().encode(unitGlobal), forKey: "Units")
                    UserDefaults.standard.set(unitGlobal.rawValue, forKey: "Units")
                    //UserDefaults.standard.set(unitGlobal, forKey: "Units")
                    let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))
                    let cell3 = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))
                    cell2?.accessoryType = .none
                    cell3?.accessoryType = .none
                }
            }
        } else if indexPath.section == 3 && indexPath.row == 1 {
            support()
        } else if indexPath.section == 3 && indexPath.row == 2 {
            openSafariVC(self)
        } else if indexPath.section == 3 && indexPath.row == 3 {
            rate()
        } else if indexPath.section == 3 && indexPath.row == 4 {
            share()
        }
    }
    
    //----
    //MARK: Other Functions
    @IBAction func switchAction(_ sender: UISwitch) {
        if waterLogSwitch.isOn {
            UserDefaults.standard.set(true, forKey: logWaterBoolKey)
        }else {
            UserDefaults.standard.set(false, forKey: logWaterBoolKey)
        }
    }
    
    func openSafariVC(_ sender: Any) {
        let url = URL(string: "https://caffeinetracker.tobiasruano.com/privacy")
        let safari = SFSafariViewController(url: url!)
        self.present(safari, animated: true)
        safari.delegate = self
    }
    
    func safariVCDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
    
    func rate() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/1476993081?mt=8&action=write-review") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func share() {
        let activityVC = UIActivityViewController(activityItems: ["Download Caffeine Tracker on the AppStore: itunes.apple.com/app/1476993081"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func support() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "[CAFFEINE TRACKER] Feedback"
            let toRecipents = ["truano@uade.edu.ar"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Couldn't Access Mail App", message: "Please report this error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            print("Unknown error: \(result)")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
