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
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        caffeineLimitTextField.delegate = self
        styleTextView()
        //continueButton.isEnabled = false
        doneButton.isHidden = true
        doneButton.alpha = 0
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if caffeineLimitTextField.text != "" {
            UserDefaults.standard.set(caffeineLimitTextField.text, forKey: "maxCaf")
        }
        if caffeineLimitTextField.text != "" && checkValidNumber() == true {
            let number = Int(caffeineLimitTextField!.text!)
            UserDefaults.standard.set(number, forKey: "maxCaf")
        }
    }
    func checkValidNumber() -> Bool {
        if let _ = Int(caffeineLimitTextField!.text!) {
            return true
        } else {
            return false
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        caffeineLimitTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
            doneButton.isHidden = false
            UIView.animate(withDuration: 1) {
                self.doneButton.alpha = 1
            }
        } else {
            view.frame.origin.y = 0
            UIView.animate(withDuration: 1, animations: {
                self.doneButton.alpha = 0
            }) { (true) in
                self.doneButton.isHidden = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}
