//
//  FirstOnboardingViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class FirstOnboardingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var caffeineTextLabelView: UIView!
    @IBOutlet weak var caffeineLimitTextField: UITextField!
    @IBOutlet weak var continueButton: CTOnboardingButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        caffeineLimitTextField.delegate = self
        
        styleTextView()
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if caffeineLimitTextField.text != "" {
            UserDefaults.standard.set(caffeineLimitTextField.text, forKey: "maxCaf")
        }
    }
    
    func styleTextView() {
        caffeineTextLabelView.layer.cornerRadius = 10
        caffeineTextLabelView.layer.shadowRadius = 10
        caffeineTextLabelView.layer.shadowColor = UIColor.lightGray.cgColor
        caffeineTextLabelView.layer.masksToBounds = false
        caffeineTextLabelView.layer.shadowOpacity = 0.5
    }
    
    deinit {
        //Stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        caffeineLimitTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
            continueButton.setTitle("Done", for: .normal)
            continueButton.isEnabled = true
        }else {
            view.frame.origin.y = 0
            continueButton.setTitle("Slide to Continue", for: .normal)
            continueButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

}
