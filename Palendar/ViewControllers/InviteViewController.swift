//
//  InviteViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import UserNotifications

class InviteViewController: UIViewController {
    
    @IBOutlet var inviteName: UITextField!
    @IBOutlet var inviteMessage: UITextField!
    
    @IBOutlet var hangOutLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var fromTimeTextField: UITextField!
    @IBOutlet var fromHourPeriodTextField: UITextField!
    @IBOutlet var toTimeTextField: UITextField!
    @IBOutlet var toHourPeriodTextField: UITextField!
    
    @IBOutlet var sendInviteButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    
    var interests:[String]?
    var selectedInterest:String?
    var userFirstName:String?
    var userLastName:String?
    var firstName:String?
    var lastName:String?
    var deviceToken:String?
    var fromTime:Int!
    var fromHourPeriod:String!
    var toTime:Int!
    var toHourPeriod:String!
    
    var key = ""
    
    var availableTimes = [String]()
    var availableTimesTo = [String]()
    
    var hourPeriods = ["AM", "PM"]
    var hourPeriodsTo = ["AM", "PM"]
    
    var fromHourPicker = UIPickerView()
    var fromHourPeriodPicker = UIPickerView()
    
    var toHourPicker = UIPickerView()
    var toHourPeriodPicker = UIPickerView()
    
    var firstIndex = 0
    var secondIndex = 0
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if firstName != nil && lastName != nil && interests != nil && userFirstName != nil && userLastName != nil {
            hangOutLabel.text! += " \(firstName!)"
            hangOutLabel.text! += " \(lastName!):"
            inviteName.text = "\(userFirstName!) \(userLastName!) wants to schedule an invite with you for: \(interests![segmentedControl.selectedSegmentIndex])"
            segmentedControl.setTitle(interests![0], forSegmentAt: 0)
            segmentedControl.setTitle(interests![1], forSegmentAt: 1)
            segmentedControl.setTitle(interests![2], forSegmentAt: 2)
            
            fromTimeTextField.inputView = fromHourPicker
            fromHourPeriodTextField.inputView = fromHourPeriodPicker
            toTimeTextField.inputView = toHourPicker
            toHourPeriodTextField.inputView = toHourPeriodPicker
            
            fromHourPicker.dataSource = self
            fromHourPicker.delegate = self
            fromHourPeriodPicker.dataSource = self
            fromHourPeriodPicker.delegate = self
            toHourPicker.dataSource = self
            toHourPicker.delegate = self
            toHourPeriodPicker.dataSource = self
            toHourPeriodPicker.delegate = self
            
            fromHourPicker.tag = 1
            fromHourPeriodPicker.tag = 2
            toHourPicker.tag = 3
            toHourPeriodPicker.tag = 4
        }
        
        if fromTime != nil && toTime != nil {
            for i in fromTime...toTime {
                if i != toTime {
                    availableTimes.append("\(i)")
                    availableTimes.append(String(i) + ":" + "15")
                    availableTimes.append(String(i) + ":" + "30")
                    availableTimes.append(String(i) + ":" + "45")
                    
                    availableTimesTo.append("\(i)")
                    availableTimesTo.append(String(i) + ":" + "15")
                    availableTimesTo.append(String(i) + ":" + "30")
                    availableTimesTo.append(String(i) + ":" + "45")
                }
                else {
                    availableTimes.append("\(i)")
                    availableTimesTo.append("\(i)")
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        inviteName.text = "\(userFirstName!) \(userLastName!) wants to schedule an invite with you for: \(interests![segmentedControl.selectedSegmentIndex])"
    }
    
    @IBAction func sendInviteClicked(_ sender: Any) {
        
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    if self.firstIndex < self.secondIndex {
                        if self.fromTimeTextField.text == nil && self.fromHourPeriodTextField.text == nil && self.toTimeTextField.text == nil && self.toHourPeriodTextField.text == nil  {
                            return
                        }
                        else {
                            self.inviteMessage.text = "From: \(self.fromTimeTextField.text!) \(self.fromHourPeriodTextField.text!) to \(self.toTimeTextField.text!) \(self.toHourPeriodTextField.text!)"
                        }
                        
                        if self.key == "Morning" {
                            if self.fromHourPeriodTextField.text == "PM" || (self.fromHourPeriodTextField.text == "PM" && self.toHourPeriodTextField.text == "PM") {
                                Toast.show(message: "Error", bgColor: .systemRed, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                return
                            }
                        }
                        else if self.key == "Noon" {
                            guard self.fromHourPeriodTextField.text == "PM" && self.toHourPeriodTextField.text == "PM" else {
                                Toast.show(message: "Error", bgColor: .systemRed, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                return
                            }
                        }
                        else if self.key == "Afternoon" {
                            guard self.fromHourPeriodTextField.text == "PM" && self.toHourPeriodTextField.text == "PM" else {
                                Toast.show(message: "Error", bgColor: .systemRed, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                return
                            }
                        }
                        else if self.key == "Evening" {
                            guard self.fromHourPeriodTextField.text == "PM" && self.toHourPeriodTextField.text == "PM" else {
                                Toast.show(message: "Error", bgColor: .systemRed, textColor: .white, labelFont: .systemFont(ofSize: 20), showIn: .top, controller: self)
                                return
                            }
                        }
                        
                        if self.deviceToken != nil {
                            //sendInvite(deviceToken: deviceToken!)
                        }
                    }
                }
                else {
                    let alertController = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL) { (_) in }
                        }
                    }
                    
                    alertController.addAction(goToSettings)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    func close() {
        UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseIn) {
            Toast.show(message: "Invite sent!", bgColor: .black, textColor: .white, labelFont: .systemFont(ofSize: 22), showIn: .top, controller: self)
        } completion: { (completed) in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func exitClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension InviteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case 1:
                return availableTimes.count
            case 2:
                return hourPeriods.count
            case 3:
                return availableTimesTo.count
            case 4:
                return hourPeriodsTo.count
            default:
                return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 1:
                return availableTimes[row]
            case 2:
                return hourPeriods[row]
            case 3:
                return availableTimesTo[row]
            case 4:
                return hourPeriodsTo[row]
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case 1:
                fromTimeTextField.text = availableTimes[row]
                firstIndex = row
            case 2:
                fromHourPeriodTextField.text = hourPeriods[row]
            case 3:
                toTimeTextField.text = availableTimesTo[row]
                secondIndex = row
            case 4:
                toHourPeriodTextField.text = hourPeriodsTo[row]
            default:
               print("")
        }
    }
}
