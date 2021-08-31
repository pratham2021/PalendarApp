//
//  PalPageViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import Firebase

class PalPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dayOfTheWeekAndDateLabel: UILabel!
    @IBOutlet var dummyLabel: UILabel!
    @IBOutlet var categoryTable: UITableView!
    
    var firstInterest = ""
    var secondInterest = ""
    var thirdInterest = ""
    
    var userId = UserManager.getUser("userId") as? String
    var selectedDate = Date()
    var userFirstName = ""
    var userLastName = ""
    var info = [Section]()
    
    var morningUsers = [User]()
    var noonUsers = [User]()
    var afterNoonUsers = [User]()
    var eveningUsers = [User]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeLabel()
        setDayView()
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        categoryTable.addSubview(refreshControl)
    }
    
    func setWelcomeLabel() {
        
        let database = Firestore.firestore()
        
        if userId == nil {
            return
        }
        
        database.collection("users").document(userId!).addSnapshotListener { (snapshot, error) in
            if error == nil && snapshot != nil {
                if snapshot!.data() != nil {
                    let data = snapshot!.data()!
                    let firstName = data["firstname"] as! String
                    self.userFirstName = firstName
                    let lastName = data["lastname"] as! String
                    self.userLastName = lastName
                    let interests = data["interests"] as? [String]
                    if interests != nil {
                        self.firstInterest = interests![0]
                        self.secondInterest = interests![1]
                        self.thirdInterest = interests![2]
                    }
                    DispatchQueue.main.async {
                        self.welcomeLabel.text = "Welcome, \(self.userFirstName)"
                    }
                }
            }
        }
    }
    
    func setDayView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dayOfTheWeekAndDateLabel.text = dateFormatter.string(from: selectedDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "EEEE"
        dummyLabel.text = newDateFormatter.string(from: selectedDate)
        
        DispatchQueue.main.async {
            self.getMorning()
        }
    }
    
    func getMorning() {
        
        let database = Firestore.firestore()
        
        database.collection("users").whereField("daysAvailable", arrayContains: dummyLabel.text!).whereField("timeOfDay", isEqualTo: "Morning").addSnapshotListener { (shot, error) in
            
            self.info = []
            self.morningUsers = []
            
            if error == nil && shot != nil {
                for document in shot!.documents {
                    if document.documentID != self.userId! {
                        let data = document.data()
                        let interests = data["interests"] as? [String]
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        if interests != nil {
                            if interests!.contains(self.firstInterest) || interests!.contains(self.secondInterest) || interests!.contains(self.thirdInterest) {
                                DispatchQueue.main.async {
                                    let user = User(firstname: data["firstname"] as! String, lastname: data["lastname"] as! String, phoneNumber: data["phoneNumber"] as! String, docID: data["uid"] as! String, age: data["age"] as! String, interests: interests!, from: data["from"] as? [String], to: data["to"] as? [String], timeOfDay: data["timeOfDay"] as! String, email: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String, fullName:  firstName + " " + lastName, isActive: data["isActive"] as! Bool)
                                    self.morningUsers.append(user)
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                let firstSection = Section(timeOfDay: "Morning (9 AM - 12 PM)", people: self.morningUsers)
                self.info.append(firstSection)
                self.getNoon()
            }
        }
    }
    
    func getNoon() {
        
        let database = Firestore.firestore()
        
        database.collection("users").whereField("daysAvailable", arrayContains: dummyLabel.text!).whereField("timeOfDay", isEqualTo: "Noon").addSnapshotListener { (shot, error) in
            
            self.noonUsers = []
            
            if error == nil && shot != nil {
                for document in shot!.documents {
                    if document.documentID != self.userId! {
                        let data = document.data()
                        let interests = data["interests"] as? [String]
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        if interests != nil {
                            if interests!.contains(self.firstInterest) || interests!.contains(self.secondInterest) || interests!.contains(self.thirdInterest) {
                                DispatchQueue.main.async {
                                    let user = User(firstname: firstName, lastname: lastName, phoneNumber: data["phoneNumber"] as! String, docID: data["uid"] as! String, age: data["age"] as! String, interests: interests!, from: data["from"] as? [String], to: data["to"] as? [String], timeOfDay: data["timeOfDay"] as! String, email: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String, fullName: firstName + " " + lastName, isActive: data["isActive"] as! Bool)
                                    self.noonUsers.append(user)
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                let secondSection = Section(timeOfDay: "Noon (12 PM - 1 PM)", people: self.noonUsers)
                self.info.append(secondSection)
                self.getAfternoon()
            }
        }
        
    }
    
    func getAfternoon() {
        let database = Firestore.firestore()
        
        database.collection("users").whereField("daysAvailable", arrayContains: dummyLabel.text!).whereField("timeOfDay", isEqualTo: "Afternoon").addSnapshotListener { (shot, error) in
            
            self.afterNoonUsers = []
            
            if error == nil && shot != nil {
                for document in shot!.documents {
                    if document.documentID != self.userId! {
                        let data = document.data()
                        let interests = data["interests"] as? [String]
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        if interests != nil {
                            if interests!.contains(self.firstInterest) || interests!.contains(self.secondInterest) || interests!.contains(self.thirdInterest) {
                                DispatchQueue.main.async {
                                    let user = User(firstname: firstName, lastname: lastName, phoneNumber: data["phoneNumber"] as! String, docID: data["uid"] as! String, age: data["age"] as! String, interests: interests!, from: data["from"] as? [String], to: data["to"] as? [String], timeOfDay: data["timeOfDay"] as! String, email: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String, fullName: firstName + " " + lastName, isActive: data["isActive"] as! Bool)
                                    self.afterNoonUsers.append(user)
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                let thirdSection = Section(timeOfDay: "Afternoon (1 PM - 5 PM)", people: self.afterNoonUsers)
                self.info.append(thirdSection)
                self.getEvening()
            }
        }
    }
    
    func getEvening() {
        let database = Firestore.firestore()
        
        database.collection("users").whereField("daysAvailable", arrayContains: dummyLabel.text!).whereField("timeOfDay", isEqualTo: "Evening").addSnapshotListener { (shot, error) in
            
            self.eveningUsers = []
            
            if error == nil && shot != nil {
                for document in shot!.documents {
                    if document.documentID != self.userId! {
                        let data = document.data()
                        let interests = data["interests"] as? [String]
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        if interests != nil {
                            if interests!.contains(self.firstInterest) || interests!.contains(self.secondInterest) || interests!.contains(self.thirdInterest) {
                                DispatchQueue.main.async {
                                    let user = User(firstname: firstName, lastname: lastName, phoneNumber: data["phoneNumber"] as! String, docID: data["uid"] as! String, age: data["age"] as! String, interests: interests!, from: data["from"] as? [String], to: data["to"] as? [String], timeOfDay: data["timeOfDay"] as! String, email: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String, fullName: firstName + " " + lastName, isActive: data["isActive"] as! Bool)
                                    self.eveningUsers.append(user)
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                let thirdSection = Section(timeOfDay: "Evening (5 PM - 8 PM)", people: self.eveningUsers)
                self.info.append(thirdSection)
                self.categoryTable.reloadData()
            }
        }
    }
    
    @objc func reload() {
        setWelcomeLabel()
        setDayView()
        refreshControl.endRefreshing()
    }
    
    @IBAction func nextDayClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let oneWeekFromNowDate = CalendarHelper().plusWeek(date: Date())
        let oneWeekFromNowStringDate = dateFormatter.string(from: oneWeekFromNowDate)
        
        if dayOfTheWeekAndDateLabel.text == oneWeekFromNowStringDate {
            return
        }
        else {
            selectedDate = CalendarHelper().plusDay(date: selectedDate)
            setDayView()
        }
    }
    
    @IBAction func previousDayClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let todayDate = dateFormatter.string(from: Date())
        
        if dayOfTheWeekAndDateLabel.text == todayDate {
            return
        }
        else {
            selectedDate = CalendarHelper().minusDay(date: selectedDate)
            setDayView()
        }
    }
    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = info[section].timeOfDay
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.textColor = UIColor(named: "labelColor")
        let headerView = UIView()
        
        headerView.addSubview(label)
        let leftConstraint = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1, constant: 20)
        let yCenterConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0)
        headerView.addConstraints([leftConstraint, yCenterConstraint])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.palPageVC = self
        cell.firstName = userFirstName
        cell.lastName = userLastName
        
        if indexPath.section == 0 {
            cell.showUsers(self.morningUsers)
            cell.sectionNumber = indexPath.section
        }
        else if indexPath.section == 1 {
            cell.showUsers(self.noonUsers)
            cell.sectionNumber = indexPath.section
        }
        else if indexPath.section == 2 {
            cell.showUsers(self.afterNoonUsers)
            cell.sectionNumber = indexPath.section
        }
        else {
            cell.showUsers(self.eveningUsers)
            cell.sectionNumber = indexPath.section
        }
        
        return cell
    }
}
