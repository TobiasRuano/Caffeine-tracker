//
//  AboutViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 31/08/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func twitterButtonPressed(_ sender: UIButton) {
        let twitter = URL(string: "twitter://user?screen_name=TobiasRuano")!
        open(twitter)
    }
    
    @IBAction func appstoreButtonPressed(_ sender: UIButton) {
        let link = "https://apps.apple.com/es/developer/tobias-ruano/id1459688284"
        let appstore = URL(string: link)!
        open(appstore)
    }
    
    @IBAction func webButtonPressed(_ sender: UIButton) {
        let url = "https://tobiasruano.com"
        openSafariVC(self, url)
    }
    
    @IBAction func icons8ButtonPressed(_ sender: UIButton) {
        let url = "https://icons8.com"
        openSafariVC(self, url)
    }
    
    func open(_ link: URL) {
        if UIApplication.shared.canOpenURL(link as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(link as URL)
            }
        }
    }
    
    func openSafariVC(_ sender: Any, _ string: String) {
        let url = URL(string: string)
        let safari = SFSafariViewController(url: url!)
        self.present(safari, animated: true)
        safari.delegate = self
    }
    
    func safariVCDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}
