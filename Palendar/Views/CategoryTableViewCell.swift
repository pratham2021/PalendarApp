//
//  CategoryTableViewCell.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var hangOutsCollection: UICollectionView!
    
    var users = [User]()
    var palPageVC:PalPageViewController?
    var sectionNumber:Int?
    var firstName:String?
    var lastName:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hangOutsCollection.dataSource = self
        hangOutsCollection.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showUsers(_ u:[User]) {
        users = u
        hangOutsCollection.reloadData()
    }

}
extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hangOutsCollection.dequeueReusableCell(withReuseIdentifier:  "hangOutCollectionCell", for: indexPath) as! HangOutCollectionCell
        cell.user = users[indexPath.row]
        cell.number = sectionNumber
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let inviteVC = storyboard.instantiateViewController(identifier: "inviteVC") as! InviteViewController
        
        inviteVC.interests = user.interests
        inviteVC.firstName = user.firstname
        inviteVC.lastName = user.lastname
        // inviteVC.deviceToken = ""
        inviteVC.fromTime = Int(user.from![0])
        inviteVC.fromHourPeriod = user.from![1]
        inviteVC.toTime = Int(user.to![0])
        inviteVC.toHourPeriod = user.to![1]
        inviteVC.userFirstName = firstName!
        inviteVC.userLastName = lastName!
        
        switch user.timeOfDay {
            case "Morning":
                inviteVC.key = "Morning"
            case "Noon":
                inviteVC.key = "Noon"
            case "Afternoon":
                inviteVC.key = "Afternoon"
            case "Evening":
                inviteVC.key = "Evening"
            default:
                inviteVC.key = ""
        }
        
        inviteVC.modalPresentationStyle = .overCurrentContext
        
        if palPageVC != nil {
            self.palPageVC!.present(inviteVC, animated: true, completion: nil)
        }
    }
}
