//
//  TimeOfDayViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import Firebase

class TimeOfDayViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
  
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var timesOfDayTable: UITableView!
    
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var fromHourField: UITextField!
    @IBOutlet var fromHourPeriodField: UITextField!
    
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var toHourField: UITextField!
    @IBOutlet var toHourPeriodField: UITextField!
    
    var data = [TimeData]()
    var selectedIndex = [IndexPath]()
    var selectedTime = [String]()
    var key = ""
    var isExpanded = false
    
    // MARK: - Picker View Declarations
    
    var morningTimes = ["9", "10", "11", "12"]
    var morningTimesTo = ["9", "10", "11", "12"]
    var noonTimes = ["12", "1"]
    var noonTimesTo = ["12", "1"]
    var afterNoonTimes = ["1", "2", "3", "4", "5"]
    var afterNoonTimesTo = ["1", "2", "3", "4", "5"]
    var eveningTimes = ["5", "6", "7", "8"]
    var eveningTimesTo = ["5", "6", "7", "8"]
    var fromHourPeriods = ["AM", "PM"]
    var toHourPeriods = ["AM", "PM"]
    
    var fromHourPicker = UIPickerView()
    var toHourPicker = UIPickerView()
    var fromHourPeriodPicker = UIPickerView()
    var toHourPeriodPicker = UIPickerView()
    let userId = UserManager.getUser("userId") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.append(TimeData(title: "Times Of the Day", timesOfTheDay: ["Morning (9 AM - 12 PM)", "Noon (12 PM - 1 PM)", "Afternoon (1 PM - 5 PM)", "Evening (5 PM - 8 PM)"], isOpened: false))
        timesOfDayTable.dataSource = self
        timesOfDayTable.delegate = self
        timesOfDayTable.allowsMultipleSelection = false
        timesOfDayTable.tableFooterView = UIView()
        timesOfDayTable.tableFooterView!.backgroundColor = .white
        
        fromHourField.inputView = fromHourPicker
        toHourField.inputView = toHourPicker
        fromHourPeriodField.inputView = fromHourPeriodPicker
        toHourPeriodField.inputView = toHourPeriodPicker
        
        fromHourPicker.dataSource = self
        fromHourPicker.delegate = self
        toHourPicker.dataSource = self
        toHourPicker.delegate = self
        fromHourPeriodPicker.dataSource = self
        fromHourPeriodPicker.delegate = self
        toHourPeriodPicker.dataSource = self
        toHourPeriodPicker.delegate = self
        
        fromHourPicker.tag = 1
        toHourPicker.tag = 2
        fromHourPeriodPicker.tag = 3
        toHourPeriodPicker.tag = 4
        scrollView.delegate = self
        
        fromHourField.delegate = self
        toHourField.delegate = self
        fromHourPeriodField.delegate = self
        toHourPeriodField.delegate = self
        
        view.backgroundColor = .white
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder., object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isExpanded {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height - 300)
            isExpanded.toggle()
        }
        else {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height + 300)
            isExpanded.toggle()
        }
    }
    
    @objc func keyboardAppear() {
        if isExpanded == false {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height + 300)
            isExpanded.toggle()
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpanded {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height - 300)
            isExpanded.toggle()
        }
    }
    
    // MARK: - Button Methods
    @IBAction func setClicked(_ sender: Any) {
        
        if fromHourField.text == "" || fromHourPeriodField.text == "" || toHourPeriodField.text == "" || toHourPeriodField.text == "" {
            return
        }
        
        switch selectedTime[0] {
            case "Morning (9 AM - 12 PM)":
                let range = 9...12
                let fromHour = Int(fromHourField.text!)
                let toHour = Int(toHourField.text!)
                
                if fromHour == nil && toHour == nil {
                    return
                }
                
                if range.contains(fromHour!) && range.contains(toHour!) {
                    
                    if fromHour! < 12 {
                        fromHourPeriodField.text = "AM"
                    }
                    else {
                        fromHourPeriodField.text = "PM"
                    }
                    
                    if toHour! < 12 {
                        toHourPeriodField.text = "AM"
                    }
                    else {
                        toHourPeriodField.text = "PM"
                    }
                    
                    if fromHour! == toHour! {
                        show(message: "You have to select a time range of at least 1 hour")
                    }
                    else if fromHour! > toHour! {
                        show(message: "Please pick a valid time range during this time of day!")
                    }
                    else {
                        let database = Firestore.firestore()
                        
                        database.collection("users").document(userId!).updateData(["timeOfDay":"Morning", "from":[fromHourField.text!, fromHourPeriodField.text!], "to":[toHourField.text!, toHourPeriodField.text!]]) { (error) in
                            
                            if error == nil {
                                DispatchQueue.main.async {
                                    Toast.show(message: "Time Set!", bgColor: .systemPurple, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case "Noon (12 PM - 1 PM)":
                let range = 1...12
                let fromHour = Int(fromHourField.text!) // 12
                let toHour = Int(toHourField.text!) // 1
                
                if fromHour == nil && toHour == nil {
                    return
                }
                
                if range.contains(fromHour!) && range.contains(toHour!) {
                    
                    fromHourPeriodField.text = "PM"
                    toHourPeriodField.text = "PM"
                    
                    if fromHour! == toHour! {
                        show(message: "You have to select a time range of at least 1 hour")
                        return
                    }
                    else if fromHour! < toHour! {
                        show(message: "Please pick a valid time range during this time of day!")
                        return
                    }
                    else {
                        
                        let database = Firestore.firestore()
                        
                        database.collection("users").document(userId!).updateData(["timeOfDay":"Noon", "from":[fromHourField.text!, fromHourPeriodField.text!], "to":[toHourField.text!, toHourPeriodField.text!]]) { (error) in
                            
                            if error == nil {
                                DispatchQueue.main.async {
                                    Toast.show(message: "Time Set!", bgColor: .systemPurple, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case "Afternoon (1 PM - 5 PM)":
                let range = 1...5
                let fromHour = Int(fromHourField.text!)
                let toHour = Int(toHourField.text!)
                
                if fromHour == nil && toHour == nil {
                    return
                }
                
                if range.contains(fromHour!) && range.contains(toHour!) {
                    
                    fromHourPeriodField.text = "PM"
                    toHourPeriodField.text = "PM"
                    
                    if fromHour! == toHour! {
                        show(message: "You have to select a time range of at least 1 hour")
                        return
                    }
                    else if fromHour! > toHour! {
                        show(message: "Please pick a valid time range during this time of day!")
                    }
                    else {
                        let database = Firestore.firestore()
                        
                        database.collection("users").document(userId!).updateData(["timeOfDay":"Afternoon", "from":[fromHourField.text!, fromHourPeriodField.text!], "to":[toHourField.text!, toHourPeriodField.text!]]) { (error) in
                            
                            if error == nil {
                                DispatchQueue.main.async {
                                    Toast.show(message: "Time Set!", bgColor: .systemPurple, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case "Evening (5 PM - 8 PM)":
                let range = 5...8
                let fromHour = Int(fromHourField.text!)
                let toHour = Int(toHourField.text!)
                
                if fromHour == nil && toHour == nil {
                    return
                }
                
                if range.contains(fromHour!) && range.contains(toHour!) {
                    
                    fromHourPeriodField.text = "PM"
                    toHourPeriodField.text = "PM"
                    
                    if fromHour! == toHour! {
                        show(message: "You have to select a range of time at least 1 hour!")
                        return
                    }
                    else if fromHour! > toHour! {
                        show(message: "Please pick a valid time range during this time of day!")
                        return
                    }
                    else {
                        
                        let database = Firestore.firestore()
                        
                        database.collection("users").document(userId!).updateData(["timeOfDay":"Evening", "from":[fromHourField.text!, fromHourPeriodField.text!], "to":[toHourField.text!, toHourPeriodField.text!]]) { (error) in
                            
                            if error == nil {
                                DispatchQueue.main.async {
                                    Toast.show(message: "Time Set!", bgColor: .systemPurple, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            default:
                print("Something wrong happened!")
        }
    }
    
    @IBAction func exitClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Picker View Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch pickerView.tag {
                case 1:
                    if key == "Morning" {
                        return morningTimes.count
                    }
                    else if key == "Noon" {
                        return noonTimes.count
                    }
                    else if key == "Afternoon" {
                        return afterNoonTimes.count
                    }
                    else if key == "Evening" {
                        return eveningTimes.count
                    }
                case 2:
                    if key == "Morning" {
                        return morningTimesTo.count
                    }
                    else if key == "Noon" {
                        return noonTimesTo.count
                    }
                    else if key == "Afternoon" {
                        return afterNoonTimesTo.count
                    }
                    else if key == "Evening" {
                        return eveningTimesTo.count
                    }
                case 3:
                    if key == "Noon" {
                        return fromHourPeriods.count
                    }
                    else if key == "Afternoon" {
                        return fromHourPeriods.count
                    }
                    else if key == "Evening" {
                        return 2
                    }
                    else {
                        return 2
                    }
                case 4:
                    if key == "Noon" {
                        return 2
                    }
                    else if key == "Afternoon" {
                        return 2
                    }
                    else if key == "Evening" {
                        return 2
                    }
                    else {
                        return 2
                    }
                default:
                    return 1
            }
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 1:
                if key == "Morning" {
                    return morningTimes[row]
                }
                else if key == "Noon" {
                    return noonTimes[row]
                }
                else if key == "Afternoon" {
                    return afterNoonTimes[row]
                }
                else if key == "Evening" {
                    return eveningTimes[row]
                }
            case 2:
                if key == "Morning" {
                    return morningTimesTo[row]
                }
                else if key == "Noon" {
                    return noonTimesTo[row]
                }
                else if key == "Afternoon" {
                    return afterNoonTimesTo[row]
                }
                else if key == "Evening" {
                    return eveningTimesTo[row]
                }
            case 3:
                if key == "Morning" {
                    return fromHourPeriods[row]
                }
                else if key == "Noon" {
                    return fromHourPeriods[row]
                }
                else if key == "Afternoon" {
                    return fromHourPeriods[row] // ["AM", "PM"][row]
                }
                else if key == "Evening" {
                    return fromHourPeriods[row] // ["AM", "PM"][row]
                }
            case 4:
                if key == "Morning" {
                    return toHourPeriods[row]
                }
                else if key == "Noon" {
                    return toHourPeriods[row]              // ["AM", "PM"][row]
                }
                else if key == "Afternoon" {
                    return toHourPeriods[row] // ["AM", "PM"][row]
                }
                else if key == "Evening" {
                    return toHourPeriods[row] // ["AM", "PM"][row]
                }
            default:
                return ""
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case 1:
                if key == "Morning" {
                    fromHourField.text = morningTimes[row]
                }
                else if key == "Noon" {
                    fromHourField.text = noonTimes[row]
                }
                else if key == "Afternoon" {
                    fromHourField.text = afterNoonTimes[row]
                }
                else if key == "Evening" {
                   fromHourField.text = eveningTimes[row]
                }
            case 2:
                if key == "Morning" {
                    toHourField.text = morningTimes[row]
                }
                else if key == "Noon" {
                    toHourField.text = noonTimes[row]
                }
                else if key == "Afternoon" {
                    toHourField.text = afterNoonTimes[row]
                }
                else if key == "Evening" {
                    toHourField.text = eveningTimes[row]
                }
            case 3:
                if key == "Morning" {
                    fromHourPeriodField.text = fromHourPeriods[row]
                    // toHourPeriodField.text = fromHourPeriods[row]

                    if (fromHourPeriodField.text == "PM" || toHourPeriodField.text == "PM") || (fromHourPeriodField.text == "PM" && toHourPeriodField.text == "PM") {
                        show(message: "Choose a valid time range during this time of day")
                    }
                    else if toHourPeriodField.text == "PM" {
                        fromHourPeriodField.text = "AM"
                    }
                }
                else if key == "Noon" {
                    fromHourPeriodField.text = fromHourPeriods[row] // "PM"
                }
                else if key == "Afternoon" {
                    fromHourPeriodField.text = fromHourPeriods[row] // "PM"
                }
                else if key == "Evening" {
                    fromHourPeriodField.text = fromHourPeriods[row] // "PM"
                }
            case 4:
                if key == "Morning" {
                    toHourPeriodField.text = toHourPeriods[row]

                    if toHourPeriodField.text == "PM" && fromHourPeriodField.text == "PM" {
                        show(message: "Choose a valid time range during this time of day")
                    }
                    else if fromHourPeriodField.text == "PM" {
                        show(message: "Invalid start time")
                    }

                }
                else if key == "Noon" {
                    toHourPeriodField.text = toHourPeriods[row] // "PM"
                }
                else if key == "Afternoon" {
                    toHourPeriodField.text = toHourPeriods[row] // "PM"
                }
                else if key == "Evening" {
                    toHourPeriodField.text = toHourPeriods[row] // "PM"
                }
            default:
                print("Bucket List: South Africa")
                print("Next Bucket List should be Australia")
        }
    }
    
    func show(message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension TimeOfDayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = data[section]
        if section.isOpened {
            return section.timesOfTheDay.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timesOfDayTable.dequeueReusableCell(withIdentifier: "timeOfDayCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = data[indexPath.section].title
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        }
        else {
            cell.textLabel?.font = .systemFont(ofSize: 16)
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            cell.textLabel?.text = data[indexPath.section].timesOfTheDay[indexPath.row - 1]
            if selectedIndex.contains(indexPath) {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            data[indexPath.section].isOpened.toggle()
            timesOfDayTable.reloadSections([indexPath.section], with: .none)
        }
        else {
            let cell = timesOfDayTable.cellForRow(at: indexPath)!
            let title = cell.textLabel?.text!
            
            if selectedIndex.count < 1 {
                selectedIndex.append(indexPath)
                selectedTime.append(title!)
                timesOfDayTable.reloadRows(at: [indexPath], with: .fade)
                switch indexPath.row {
                    case 1:
                        key = "Morning"
                    case 2:
                        key = "Noon"
                    case 3:
                        key = "Afternoon"
                    case 4:
                        key = "Evening"
                    default:
                        key = ""
                }
                fromLabel.alpha = 1
                fromHourField.alpha = 1
                fromHourPeriodField.alpha = 1
                toLabel.alpha = 1
                toHourField.alpha = 1
                toHourPeriodField.alpha = 1
                
                Utilities.styleTextField(fromHourField)
                Utilities.styleTextField(fromHourPeriodField)
                Utilities.styleTextField(toHourField)
                Utilities.styleTextField(toHourPeriodField)
                
                fromHourPicker.reloadAllComponents()
                toHourPicker.reloadAllComponents()
                fromHourPeriodPicker.reloadAllComponents()
                toHourPeriodPicker.reloadAllComponents()
            }
            // The cell that we have already selected
            else if selectedIndex.count == 1 && selectedIndex.contains(indexPath) {
                
                selectedIndex.removeAll { (selected) in
                    selected == indexPath
                }
                
                selectedTime.removeAll { (selectedTime) in
                    selectedTime == title!
                }
                
                key = ""
                
                timesOfDayTable.reloadRows(at: [indexPath], with: .fade)
                
                fromLabel.alpha = 0
                fromHourField.alpha = 0
                fromHourPeriodField.alpha = 0
                toLabel.alpha = 0
                toHourField.alpha = 0
                toHourPeriodField.alpha = 0
                
                fromHourField.text = ""
                fromHourPeriodField.text = ""
                toHourField.text = ""
                toHourPeriodField.text = ""
                
                fromHourPicker.reloadAllComponents()
                toHourPicker.reloadAllComponents()
                fromHourPeriodPicker.reloadAllComponents()
                toHourPeriodPicker.reloadAllComponents()
            }
        }
    }

}

extension TimeOfDayViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == fromHourField {
            fromHourField.resignFirstResponder()
            fromHourPeriodField.becomeFirstResponder()
        }
        else if textField == fromHourPeriodField {
            fromHourPeriodField.resignFirstResponder()
            toHourField.becomeFirstResponder()
        }
        else if textField == toHourField {
            toHourField.resignFirstResponder()
            toHourPeriodField.becomeFirstResponder()
        }
        else if textField == toHourPeriodField {
            view.endEditing(true)
        }
        
        return true
    }
}
