//
//  AvailabilityViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import Firebase

class AvailabilityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var data = [DayData]()
    
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    let weekends = ["Saturday", "Sunday"]
    
    var selectedIndex = [IndexPath]()
    
    var selectedDays = [String]()
    
    var userId = UserManager.getUser("userId") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data.append(DayData(title: "Weekdays", days: weekdays, isOpened: false))
        data.append(DayData(title: "Weekends", days: weekends, isOpened: false))
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        print(selectedDays)
        
        let database = Firestore.firestore()
        
        database.collection("users").document(userId!).updateData(["daysAvailable":selectedDays]) { (error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        Toast.show(message: "Your days of availability were all set!", bgColor: .black, textColor: .white, labelFont: .systemFont(ofSize: 22), showIn: .top, controller: self)
                    }
                }
            }
        }
        
    }
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = data[section]
        if section.isOpened {
            return section.days.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = data[indexPath.section].title
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            cell.accessoryType = .none
        }
        else {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            cell.textLabel?.text = " \(data[indexPath.section].days[indexPath.row - 1])"
            
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            data[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }
        else {
            let cell = tableView.cellForRow(at: indexPath)!
            let title = cell.textLabel?.text!.trimmingCharacters(in: .whitespaces)
            
            if selectedIndex.contains(indexPath) {
                selectedIndex.removeAll { (selectedIndex) in
                    selectedIndex == indexPath
                }
                selectedDays.removeAll { (dayOfWeek) in
                    dayOfWeek == title!
                }
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            else {
                selectedIndex.append(indexPath)
                selectedDays.append(title!)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
