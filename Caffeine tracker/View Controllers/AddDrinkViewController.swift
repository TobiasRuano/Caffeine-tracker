//
//  AddDrinkViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 12/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class AddDrinkViewController: UIViewController {

    @IBOutlet weak var DrinkName: UITextField!
    @IBOutlet weak var caffeineAmount: UITextField!
    
    var drinkToAdd: drink = drink(type: "", caffeineML: 0, caffeineOZ: 0)
    
    var vc: HomeTableViewController?
    
    @IBOutlet var save: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DrinkName.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    @IBAction func save(_ sender: UIBarButtonItem) {
////        if DrinkName.text != "" && caffeineAmount.text != "" {
////            var drinkToAdd: drink?
////            drinkToAdd?.type = DrinkName.text!
////            drinkToAdd?.caffeineML = Int(caffeineAmount.text!)!
////            vc?.passData(data: drinkToAdd!)
////
////            //Taptic feedback
////            let generator = UINotificationFeedbackGenerator()
////            generator.notificationOccurred(.success)
////            self.dismiss(animated: true, completion: nil)
////        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if DrinkName.text != "" && caffeineAmount.text != "" {
            drinkToAdd.type = DrinkName.text!
            print(DrinkName.text!)
            drinkToAdd.caffeineML = Int(caffeineAmount.text!)!
            drinkToAdd.caffeineOZ = Int(caffeineAmount.text!)!
            print(drinkToAdd)


            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        textViewStyle(element: DrinkName)
        textViewStyle(element: caffeineAmount)
    }
    
    func textViewStyle(element: UITextField){
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor(displayP3Red: 0.737, green: 0.733, blue: 0.757, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: element.frame.size.height - width, width:  element.frame.size.width, height: element.frame.size.height)
        
        border.borderWidth = width
        element.layer.addSublayer(border)
        element.layer.masksToBounds = true
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
