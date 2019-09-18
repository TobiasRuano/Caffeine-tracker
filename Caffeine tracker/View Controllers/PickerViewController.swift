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
    @IBOutlet weak var fondoView: UIView!
    
    var arrayML = [Int](0...100)
    var arrayUSoz = [Int](0...34)
    var arrayUKoz = [Int](0...35)
    var seleccion = 0.0
    var result = 0
    var toSave: drink = drink(type: "", caffeineMg: 0, mililiters: 0, icon: "", dia: nil)
    var waterLog: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waterLog = UserDefaults.standard.value(forKey: logWaterBoolKey) as! Bool
        style()
        retriveData()
        if toSave.getCaffeineMg() >= 200 {
            fondo.layer.backgroundColor = UIColor.red.cgColor
        }
        changeStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        effectView()
    }
    
    func changeStyle() {
        pickerView.backgroundColor = UIColor(named: "BackgroundGeneral")
        fondoView.backgroundColor = UIColor(named: "BackgroundGeneral")
        fondo.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        shadowNavBar.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch unitGlobal {
        case .ml:
            return arrayML.count
        case .flOzUS:
            return arrayUSoz.count
        case .flOzUK:
            return arrayUKoz.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch unitGlobal {
        case .ml:
            return "\(arrayML[row]) ml"
        case .flOzUS:
            return "\(arrayUSoz[row]) fl oz"
        case .flOzUK:
            return "\(arrayUKoz[row]) fl oz"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch unitGlobal {
        case .ml:
            seleccion = Double(arrayML[row])
            result = (arrayML[row] * Int(toSave.getCaffeineMg())) / 100
        case .flOzUS:
            seleccion = Double(arrayUSoz[row])
            result = Int((Double(arrayUSoz[row]) * toSave.getCaffeineMg()) / 3.0)
        case .flOzUK:
            seleccion = Double(arrayUKoz[row])
            result = Int((Double(arrayUKoz[row]) * toSave.getCaffeineMg()) / 3.0)
        }
        titulo.text = "Drink: \(toSave.getName())\nCaffeine: \(result)mg"
        if result >= 200 {
            fondo.layer.backgroundColor = UIColor.red.cgColor
        } else {
            fondo.layer.backgroundColor = UIColor(red: 0.0, green: 0.478, blue: 1.000, alpha: 1.0).cgColor
        }
        if row != 0 {
            doneButton.isEnabled = true
        } else if row == 0 {
            doneButton.isEnabled = false
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            self.delegate?.removeTintBackground()
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.removeTintBackground()
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
        if vista != shadowNavBar {
            vista.layer.cornerRadius = 8.0
        }
        vista.layer.shadowColor = UIColor.lightGray.cgColor
        vista.layer.shadowOpacity = 1
        vista.layer.shadowOffset = CGSize.zero
        vista.layer.shadowRadius = 5
    }
    
    fileprivate func retriveData() {
        // Retrive data
        let data = UserDefaults.standard.value(forKey: toSaveKey) as? Data
        toSave = try! PropertyListDecoder().decode(drink.self, from: data!)
        let caffeine = Int(toSave.getCaffeineMg())
        titulo.text = "Drink: \(toSave.getName())\nCaffeine: \(caffeine)mg"
        result = Int(toSave.getCaffeineMg())
        print(result)
        populateTableView()
    }
    
    fileprivate  func populateTableView() {
        switch unitGlobal {
        case .ml:
            pickerView.selectRow(10, inComponent: 0, animated: false)
            for element in arrayML{
                if element < arrayML.count {
                    arrayML[element] = arrayML[element]*10
                }
            }
        case .flOzUS:
            pickerView.selectRow(3, inComponent: 0, animated: false)
        case .flOzUK:
            pickerView.selectRow(3, inComponent: 0, animated: false)
        }
    }
}
