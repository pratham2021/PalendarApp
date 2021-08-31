//  AboutTableViewController.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/22/2021.

import UIKit

class AboutTableViewController: UITableViewController {
    // MARK: - IBOutlets and Variables
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var isActiveLabel: UILabel!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        setUpUI()
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            print("Start chatting")
            // TODO: Go to chat room.
        }
    }
    
    // MARK: - UI Functions
    private func setUpUI() {
        if user != nil {
            title = user!.fullName
            userNameLabel.text = user!.fullName
            isActiveLabel.text =  user!.isActive ? "Active now":"Offline"
            
            if user!.profilePictureUrl != nil {
                FileStorage().downloadImage(imageUrl: user!.profilePictureUrl!) { (image) in
                    if image != nil {
                        DispatchQueue.main.async {
                            self.userProfileImageView.clipsToBounds = true
                            self.userProfileImageView.image = image!.circleMasked
                        }
                    }
                }
            }
        }
    }
}
