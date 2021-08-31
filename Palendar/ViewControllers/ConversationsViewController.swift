//  ConversationsViewController.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/23/2021.

import UIKit
import Firebase

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var conversationsTable: UITableView!
    
    var users = [User]()
    var morningUsers = [User]()
    var noonUsers = [User]()
    var afterNoonUsers = [User]()
    var eveningUsers = [User]()
    let db = Firestore.firestore()
    let userId = UserManager.getUser("userId") as? String
    
    var firstInterest = ""
    var secondInterest = ""
    var thirdInterest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMorning()
        conversationsTable.dataSource = self
        conversationsTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "randomTableCell", for: indexPath) as! RecentTableViewCell
        
        return cell
    }
    
    func getMorning() {
        
        db.collection("users").whereField("timeOfDay", isEqualTo: "Morning").addSnapshotListener { (snapshot, error) in
            
            self.users = []
            self.morningUsers = []
            
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    if document.documentID != self.userId! {
                        let data = document.data()
                        let interests = data["interests"] as? [String]
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        if interests != nil {
                            if interests!.contains(self.firstInterest) || interests!.contains(self.secondInterest) || interests!.contains(self.thirdInterest) {
                                DispatchQueue.main.async {
                                    let user = User(firstname: firstName, lastname: lastName, phoneNumber: data["phoneNumber"] as! String, docID: data["uid"] as! String, age: data["age"] as! String, interests: interests!, from: data["from"] as? [String], to: data["to"] as? [String], timeOfDay: data["timeOfDay"] as! String, email: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String, fullName: firstName + " " + lastName, isActive: data["isActive"] as! Bool)
                                    self.morningUsers.append(user)
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.users.append(contentsOf: self.morningUsers)
                self.getNoon()
            }
        }
    }
    
    func getNoon() {
        
        
        db.collection("users").whereField("timeOfDay", isEqualTo: "Noon").addSnapshotListener { (snapshot, error) in
            
            self.noonUsers = []
            
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
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
                self.users.append(contentsOf: self.noonUsers)
                self.getAfternoon()
            }
        }
        
    }
    
    func getAfternoon() {
        
        db.collection("users").whereField("timeOfDay", isEqualTo: "Afternoon").addSnapshotListener { (snapshot, error) in
            
            self.afterNoonUsers = []
            
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
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
                self.users.append(contentsOf: self.afterNoonUsers)
                self.getEvening()
            }
        }
        
    }
    
    func getEvening() {
        
        db.collection("users").whereField("timeOfDay", isEqualTo: "Evening").addSnapshotListener { (snapshot, error) in
            
            self.eveningUsers = []
            
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
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
                self.users.append(contentsOf: self.eveningUsers)
               // Reload the table view
            }
        }
        
    }
    
}
