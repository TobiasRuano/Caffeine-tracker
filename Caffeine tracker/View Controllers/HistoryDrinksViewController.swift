//
//  RecentsDrinksViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 14/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class HistoryDrinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todaysCaffeine: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var mgLabel: UILabel!
    @IBOutlet weak var yesterdaysCaffeine: UILabel!
    @IBOutlet weak var tablewView: UITableView!
    @IBOutlet weak var progress: UIProgressView!
    
    var caffeineLimit = 400
    var drinksDictionary = [Int : [drink]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //separateDrinksInSections()
        progressViewStyle()
        //tablewView.reloadData()
        tablewView.tableFooterView = UIView()
    }
    
    func separateDrinksInSections() {
        var elementsArray = [drink]()
        print("Right now i have this many drinks in the arrayDrinksAdded: \(arrayDrinksAdded.count) and they are: \(arrayDrinksAdded)")
        var sumador = 0
        for element in arrayDrinksAdded.reversed() {
            print("Drink: \(element.type), ml: \(element.mililiters) date: \(element.date)")
            let day = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).day
            let month = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).month
            let year = Calendar.current.dateComponents([.day, .month, .year], from: element.date!).year
            
            
            if elementsArray.count == 0 {
                elementsArray.append(element)
                drinksDictionary[sumador] = elementsArray
            } else {
                let elementArrayDay = Calendar.current.dateComponents([.day, .year, .month], from: elementsArray[0].date!).day
                let elementArrayMonth = Calendar.current.dateComponents([.day, .year, .month], from: elementsArray[0].date!).month
                let elementArrayYear = Calendar.current.dateComponents([.day, .month, .year], from: elementsArray[0].date!).year
                
                if elementArrayDay == day && elementArrayMonth == month && elementArrayYear == year {
                    //                    elementsArray.append(element)
                    //                    drinksDictionary[sumador] = elementsArray
                    drinksDictionary[sumador]?.append(element)
                } else {
                    while drinksDictionary[sumador] != nil {
                        sumador += 1
                    }
                    elementsArray.removeAll()
                    elementsArray.append(element)
                    drinksDictionary[sumador] = elementsArray
                }
            }
        }
        print(drinksDictionary)
        //sortDrinksByDay()
        print(drinksDictionary)
    }
    
    //    func sortDrinksByDay() {
    //        var auxArray = [drink]()
    //        print(drinksDictionary)
    //
    //        for i in 0..<drinksDictionary.count - 1 {
    //            for j in 1..<drinksDictionary.count {
    //                print(drinksDictionary[i]![0].date!)
    //                if drinksDictionary[i]![0].date! < drinksDictionary[j]![0].date! {
    //                    auxArray = drinksDictionary[i]!
    //                    drinksDictionary[i] = drinksDictionary[j]!
    //                    drinksDictionary[j] = auxArray
    //                }
    //            }
    //            print("")
    //        }
    //        print(drinksDictionary)
    //        displayCaffeineProgress()
    //
    //    }
    
    
    func displayCaffeineProgress() {
        checkTodaysAndYesterdaysCaffeine()
        let value = caffeineLimit - Int(todaysCaffeine.text!)!
        progress.setProgress((Float(value) / Float(caffeineLimit)), animated: true)
        
        changeLabelColor()
    }
    
    func changeLabelColor() {
        if progress.progress == 0 {
            UIView.transition(with: todaysCaffeine, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.todaysCaffeine.textColor = .red
                self.mgLabel.textColor = .red
                self.todayLabel.textColor = .red
            }, completion: nil)
        }else {
            UIView.transition(with: todaysCaffeine, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.todaysCaffeine.textColor = .black
                self.mgLabel.textColor = .black
                self.todayLabel.textColor = .black
            }, completion: nil)
        }
    }
    
    func checkTodaysAndYesterdaysCaffeine() {
        let date = Date()
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        var yesterday = date
        yesterday.addTimeInterval(-86400)
        let yesterdaysDate = Calendar.current.dateComponents([.day, .year, .month], from: yesterday)
        //Today's
        todaysCaffeine.text = "0"
        //        for element in arrayDrinksAdded {
        //            let day = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).day
        //            let month = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).month
        //            if day == calanderDate.day && month == calanderDate.month {
        //                let caffeineNumber = Int(todaysCaffeine.text!)
        //                todaysCaffeine.text = "\(caffeineNumber! + element.caffeineMg)"
        //            }
        //        }
        if let firstElement = drinksDictionary[0]?[0] {
            let day = Calendar.current.dateComponents([.day, .year, .month], from: firstElement.date!).day
            let month = Calendar.current.dateComponents([.day, .year, .month], from: firstElement.date!).month
            if day == calanderDate.day && month == calanderDate.month {
                var totalCaffeine = 0
                for element in drinksDictionary[0]! {
                    totalCaffeine += element.caffeineMg
                }
                todaysCaffeine.text = "\(totalCaffeine)"
                //                let caffeineNumber = Int(todaysCaffeine.text!)
                //                todaysCaffeine.text = "\(caffeineNumber! + firstElement.caffeineMg)"
            }
        }
        //Yesterday's
        yesterdaysCaffeine.text = "0"
        if let secondElement = drinksDictionary[1]?[0] {
            let day = Calendar.current.dateComponents([.day, .year, .month], from: secondElement.date!).day
            let month = Calendar.current.dateComponents([.day, .year, .month], from: secondElement.date!).month
            if day == yesterdaysDate.day && month == yesterdaysDate.month {
                var totalCaffeine = 0
                for element in drinksDictionary[1]! {
                    totalCaffeine += element.caffeineMg
                }
                yesterdaysCaffeine.text = "\(totalCaffeine)"
                //                let caffeineNumber = Int(yesterdaysCaffeine.text!)
                //                yesterdaysCaffeine.text = "\(caffeineNumber! + secondElement.caffeineMg)"
            } else if let firstElement = drinksDictionary[0]?[0] {
                let day = Calendar.current.dateComponents([.day, .year, .month], from: firstElement.date!).day
                let month = Calendar.current.dateComponents([.day, .year, .month], from: firstElement.date!).month
                if day == yesterdaysDate.day && month == yesterdaysDate.month {
                    var totalCaffeine = 0
                    for element in drinksDictionary[0]! {
                        totalCaffeine += element.caffeineMg
                    }
                    yesterdaysCaffeine.text = "\(totalCaffeine)"
                }
            }
        }
        //        for element in arrayDrinksAdded {
        //            var yesterday = date
        //            yesterday.addTimeInterval(-86400)
        //            let yesterdaysDate = Calendar.current.dateComponents([.day, .year, .month], from: yesterday)
        //            let day = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).day
        //            let month = Calendar.current.dateComponents([.day, .year, .month], from: element.date!).month
        //            if day == yesterdaysDate.day && month == yesterdaysDate.month {
        //                let caffeineNumber = Int(yesterdaysCaffeine.text!)
        //
        //                yesterdaysCaffeine.text = "\(caffeineNumber! + element.caffeineMg)"
        //            }
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drinksDictionary.removeAll()
        
        if let number = UserDefaults.standard.value(forKey: "maxCaf") as? Int {
            caffeineLimit = number
        }
        
        if let data = UserDefaults.standard.value(forKey: arrayDrinksAddedKey) as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
        }
        
        separateDrinksInSections()
        //this func shows todays and yesterdays caffeine ammount on progress bar and text
        displayCaffeineProgress()
        tablewView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drinksDictionary.count
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var date = Date()
        if let value = drinksDictionary[section] {
            date = value[0].date!
            let day = Calendar.current.dateComponents([.day, .year, .month], from: date).day
            let month = Calendar.current.dateComponents([.day, .year, .month], from: date).month
            let year = Calendar.current.dateComponents([.day, .month, .year], from: date).year
            
            let today = Date()
            let todaysDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
            
            var yesterday = Date()
            yesterday.addTimeInterval(-86400)
            let yesterdaysDate = Calendar.current.dateComponents([.day, .year, .month], from: yesterday)
            
            if todaysDate.day == day && todaysDate.month == month && todaysDate.year == year {
                return "Today"
            }else if (yesterdaysDate.day == day && yesterdaysDate.month == month && yesterdaysDate.year == year){
                return "Yesterday"
            }else {
                let fullDate = "\(day!)/\(month!)/\(year!)"
                return fullDate
            }
        }else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        if #available(iOS 13.0, *) {
            view.tintColor = UIColor.link
        } else {
            view.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        }
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        if !drinksDictionary.isEmpty {
            value = drinksDictionary[section]!.count
        }
        print("La seccion es: \(section) y la cantidad de elementos es: \(value)")
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyTableViewCell, for: indexPath) as! CustomCellClass
        cell.DrinkName.text = drinksDictionary[indexPath.section]![indexPath.row].type
        cell.caffeineMg.text = "\(drinksDictionary[indexPath.section]![indexPath.row].caffeineMg)mg"
        cell.miliLiters.text = "\(drinksDictionary[indexPath.section]![indexPath.row].mililiters)ml"
        cell.imageView?.image = UIImage(named: drinksDictionary[indexPath.section]![indexPath.row].icon)
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    ////            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(arrayDrinksAdded.reversed()[indexPath.row].caffeineMg)mg of \(arrayDrinksAdded.reversed()[indexPath.row].type)?", preferredStyle: .actionSheet)
    //            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(drinksDictionary[indexPath.section]![indexPath.row].caffeineMg)mg of \(drinksDictionary[indexPath.section]![indexPath.row].type)?", preferredStyle: .actionSheet)
    //
    ////            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
    ////                print("User click Delete button")
    ////                let indice = (arrayDrinksAdded.count - (indexPath.row + 1))
    ////                arrayDrinksAdded.remove(at: indice);
    ////                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: arrayDrinksAddedKey)
    ////                tableView.deleteRows(at: [indexPath], with: .automatic)
    ////
    ////                //Taptic feedback
    ////                let generator = UINotificationFeedbackGenerator()
    ////                generator.notificationOccurred(.warning)
    ////
    ////                self.checkTodaysAndYesterdaysCaffeine()
    ////                self.displayCaffeineProgress()
    ////            }))
    //
    //            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
    //                print("User click Delete button")
    //
    //                var test = 0
    //                while arrayDrinksAdded[test].date != self.drinksDictionary[indexPath.section]![indexPath.row].date {
    //                    test += 1
    //                }
    //                arrayDrinksAdded.remove(at: test)
    //                self.drinksDictionary[indexPath.section]?.remove(at: indexPath.row)
    //                if self.drinksDictionary[indexPath.section] == nil {
    //                    self.drinksDictionary.removeValue(forKey: indexPath.section)
    //                }
    //
    //                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: arrayDrinksAddedKey)
    //                tableView.deleteRows(at: [indexPath], with: .automatic)
    //
    //                //Taptic feedback
    //                let generator = UINotificationFeedbackGenerator()
    //                generator.notificationOccurred(.warning)
    //
    //                self.checkTodaysAndYesterdaysCaffeine()
    //                self.displayCaffeineProgress()
    //            }))
    //
    //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
    //                print("User click Cancel button")
    //            }))
    //
    //            self.present(alert, animated: true, completion: {
    //                print("ActionSheet action completed!")
    //            })
    //        }
    //    }
    
    func progressViewStyle() {
        // Progress View Style
        let gradientView = GradientView(frame: progress.bounds)
        //convert gradient view to image, flip horizontally and assign as the track image
        progress.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        //invert the progress view
        progress.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        progress.progressTintColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        progress.layer.cornerRadius = 8.0
        progress.layer.shadowColor = UIColor.lightGray.cgColor
        progress.layer.shadowOpacity = 1
        progress.layer.shadowOffset = CGSize.zero
        progress.layer.shadowRadius = 5
        self.progress.clipsToBounds = true
    }
}
