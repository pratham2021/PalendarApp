//  ChatDashboardViewController.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/11/2021.

import UIKit
import Firebase

class ChatDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var messagesTable: UITableView!
    
    var users = [User]()
    var morningUsers = [User]()
    var noonUsers = [User]()
    var afterNoonUsers = [User]()
    var eveningUsers = [User]()
    var filteredUsers = [User]()
    
    let userId = UserManager.getUser("userId") as? String
    var dayOfTheWeek = ""
    var userFirstName = ""
    var userLastName = ""
    var firstInterest = ""
    var secondInterest = ""
    var thirdInterest = ""
    let db = Firestore.firestore()
    var refreshControl = UIRefreshControl()
    let searchcontroller = UISearchController(searchResultsController: nil)
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        getUserInterests()
        work()
        messagesTable.tableFooterView = UIView()
        messagesTable.dataSource = self
        messagesTable.delegate = self
        messagesTable.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshReload), for: .valueChanged)
        messagesTable.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UI Functions
    @objc func refreshReload() {
        getUserInterests()
        work()
        refreshControl.endRefreshing()
    }
    
    func filteredContentForSearchText(searchText:String) {
        filteredUsers = users.filter({ (user) in
            // user.firstname == searchText
            return user.fullName.lowercased().contains(searchText.lowercased())
        })
        messagesTable.reloadData()
    }
    
    private func setUpSearchController() {
        navigationItem.searchController = searchcontroller
        navigationItem.hidesSearchBarWhenScrolling = true
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchBar.placeholder = "Search For A User"
        searchcontroller.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func getUserInterests() {
        
        if userId != nil {
            db.collection("users").document(userId!).addSnapshotListener { (snapshot, error) in
                
                if error == nil && snapshot != nil {
                    if snapshot!.data() != nil {
                        let data = snapshot!.data()!
                        let firstName = data["firstname"] as! String
                        self.userFirstName = firstName
                        let lastName = data["lastname"] as! String
                        self.userLastName = lastName
                        let interests = data["interests"] as? [String]
                        
                        if interests != nil {
                            DispatchQueue.main.async {
                                self.firstInterest = interests![0]
                                self.secondInterest = interests![1]
                                self.thirdInterest = interests![2]
                            }
                        }
                    }
                }
            }
        }
    }
    
    func work() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE"
        dayOfTheWeek = dateformatter.string(from: Date())
        DispatchQueue.main.async {
            self.getMorning()
        }
    }
    
    func getMorning() {
        
        db.collection("users").limit(to: 10).whereField("timeOfDay", isEqualTo: "Morning").addSnapshotListener { (snapshot, error) in
            
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
      
        db.collection("users").limit(to: 10).whereField("timeOfDay", isEqualTo: "Noon").addSnapshotListener { (snapshot, error) in
            
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
        
        db.collection("users").limit(to: 10).whereField("timeOfDay", isEqualTo: "Afternoon").addSnapshotListener { (snapshot, error) in
            
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
        
        db.collection("users").limit(to: 10).whereField("timeOfDay", isEqualTo: "Evening").addSnapshotListener { (snapshot, error) in
            
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
                self.messagesTable.reloadData()
            }
        }
    }
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchcontroller.isActive ? filteredUsers.count: users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTable.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        let user = searchcontroller.isActive ? filteredUsers[indexPath.row]:users[indexPath.row]
        cell.decorateCell(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = searchcontroller.isActive ? filteredUsers[indexPath.row]:users[indexPath.row]
        
        let aboutTableVC = storyboard?.instantiateViewController(identifier: "aboutTableVC") as! AboutTableViewController
        aboutTableVC.user = user
        self.navigationController?.pushViewController(aboutTableVC, animated: true)
    }
    // MARK: - Search Bar Methods
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
