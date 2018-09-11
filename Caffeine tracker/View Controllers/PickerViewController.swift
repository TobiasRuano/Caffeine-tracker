//
//  PickerViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: HomeViewController?
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var fondo: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var shadowNavBar: UIView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var arrayML = [Int](0...100)
    var seleccion = 0
    var result = 0
    var toSave: drink = drink(type: "", caffeineML: 0, caffeineOZ: 0, icon: "")
    var waterLog: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waterLog = UserDefaults.standard.value(forKey: logWaterBoolKey) as! Bool
        style()
        retriveData()
        
        if toSave.caffeineML >= 200 {
            fondo.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        effectView()
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
    
    func effectView() {
        let number = self.fondo.layer.frame.height + 73 + 22
        UIView.animate(withDuration: 0.2, animations: {
            self.fondo.transform = CGAffineTransform(translationX: 0, y: -number)
        })
    }
    
    fileprivate func style() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        indepthStyle(fondo)
        indepthStyle(shadowNavBar)
    }
    
    fileprivate func indepthStyle(_ vista: UIView) {
        vista.layer.cornerRadius = 8.0
        vista.layer.shadowColor = UIColor.lightGray.cgColor
        vista.layer.shadowOpacity = 1
        vista.layer.shadowOffset = CGSize.zero
        vista.layer.shadowRadius = 5
    }
    
    fileprivate func retriveData() {
        // Retrive data
        let data = UserDefaults.standard.value(forKey: toSaveKey) as? Data
        toSave = try! PropertyListDecoder().decode(drink.self, from: data!)
        print(toSave)
        titulo.text = "Drink: \(toSave.type)\nCaffeine: \(toSave.caffeineML)mg"
        result = toSave.caffeineML
        print(result)
        
        populateTableView()
    }
    
    fileprivate  func populateTableView() {
        pickerView.selectRow(10, inComponent: 0, animated: false)
        for element in arrayML{
            if element < arrayML.count {
                arrayML[element] = arrayML[element]*10
            }
        }
    }
}
