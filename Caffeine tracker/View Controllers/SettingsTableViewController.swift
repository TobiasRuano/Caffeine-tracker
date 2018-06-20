//
//  SettingsTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 && indexPath.row == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
            share()
        }else if indexPath.section == 3 && indexPath.row == 1 {
            //let appDelegate = AppDelegate()
            //appDelegate.requestReview()
            tableView.deselectRow(at: indexPath, animated: true)
            rate()
        }else if indexPath.section == 3 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            support()
        }else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    let cell2 = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))
                    cell2?.accessoryType = .none
                }
            }
        }else if indexPath.section == 1 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))
                    cell2?.accessoryType = .none
                }
            }
        }
    }
    
    // Other Functions
    
    func rate() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func share() {
        let activityVC = UIActivityViewController(activityItems: ["Download Caffeine Tracker on the AppStore: itunes.apple.com/app/idYOUR_APP_ID"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func support() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "[CAFFEINE TRACKER] Feedback"
            let toRecipents = ["ruano.t10@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Couldn't Access Mail App", message: "Please report this error", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
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
        }
        controller.dismiss(animated: true, completion: nil)
    }

}