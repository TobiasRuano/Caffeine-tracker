//
//  PickerViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var titulo: UILabel!
    weak var delegate: HomeTableViewController?
    var arrayML = [Int](0...100)
    var seleccion = 0
    @IBOutlet weak var fondo: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var shadowNavBar: UIView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var result = 0
    var toSave: drink = drink(type: "", caffeineML: 0, caffeineOZ: 0, icon: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        fondo.layer.cornerRadius = 8.0
        fondo.layer.shadowColor = UIColor.lightGray.cgColor
        fondo.layer.shadowOpacity = 1
        fondo.layer.shadowOffset = CGSize.zero
        fondo.layer.shadowRadius = 5
        
        shadowNavBar.layer.cornerRadius = 8.0
        shadowNavBar.layer.shadowColor = UIColor.lightGray.cgColor
        shadowNavBar.layer.shadowOpacity = 1
        shadowNavBar.layer.shadowOffset = CGSize.zero
        shadowNavBar.layer.shadowRadius = 5
        
        // Retrive data
        let data = UserDefaults.standard.value(forKey:"tosave") as? Data
        toSave = try! PropertyListDecoder().decode(drink.self, from: data!)
        print(toSave)
        titulo.text = "Drink: \(toSave.type)\nCaffeine: \(toSave.caffeineML)mg"
        result = toSave.caffeineML
        print(result)
        
        pickerView.selectRow(10, inComponent: 0, animated: false)
        for element in arrayML{
            if element < arrayML.count {
                arrayML[element] = arrayML[element]*10
            }
        }
        blur.isHidden = true
////        view.backgroundColor = UIColor.darkGray
////        view.alpha = 0.4
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            self.blur.isHidden = false
//        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayML.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(arrayML[row])ml"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seleccion = arrayML[row]
        result = (arrayML[row] * toSave.caffeineML) / 100
        titulo.text = "Drink: \(toSave.type)\nCaffeine: \(result)mg"
        if result >= 200 {
            fondo.layer.backgroundColor = UIColor.red.cgColor
        }else {
            fondo.layer.backgroundColor = UIColor(red: 0.0, green: 0.478, blue: 1.000, alpha: 1.0).cgColor
        }
        if row != 0 {
            doneButton.isEnabled = true
        }else if row == 0 {
            doneButton.isEnabled = false
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Done(_ sender: UIBarButtonItem) {
        let healthManager = HealthKitSetupAssistant()
        //no guarda correctamente cuando no se mueve la seleccion del picker
        if seleccion != 0 {
            result = (seleccion * toSave.caffeineML) / 100
        }
        if result != 0 {
            self.toSave.caffeineML = result
            healthManager.submitCaffeine(CaffeineAmount: result, WaterAmount: seleccion, forDate: Date())
            arrayDrinksAdded.append(self.toSave)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: "arrayAdded")
            print(self.toSave)
            print(arrayDrinksAdded)
            
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            self.dismiss(animated: true, completion: nil)
        }
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
