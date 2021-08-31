//  RecentTableViewCell.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/23/2021.

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var lastMessageSentLabel: UILabel!
    @IBOutlet var someView: UIView!
    @IBOutlet var numberOfUnreadMessagesCounterLabel: UILabel!
    @IBOutlet var datelabel: UILabel!
    
    // view did load function of the table view cell
    override func awakeFromNib() {
        super.awakeFromNib()
        someView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recent:RecentChat) {
        userLabel.text = recent.senderName // recieverName
        userLabel.adjustsFontSizeToFitWidth = true
        userLabel.minimumScaleFactor = 0.9
        
        lastMessageSentLabel.text = recent.lastMessage
        lastMessageSentLabel.adjustsFontSizeToFitWidth = true
        lastMessageSentLabel.numberOfLines = 2
        userLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            self.numberOfUnreadMessagesCounterLabel.text = "\(recent.unreadCounter)"
            self.someView.isHidden = false
        }
        else {
            self.someView.isHidden = true
        }
        setProfileImage(link: recent.profilePictureLink)
        let globalFunctions = GlobalFunctions()
        datelabel.text = globalFunctions.timeElapsed(recent.date)
        datelabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setProfileImage(link:String) {
        if link != "" {
            let fileStorage = FileStorage()
            fileStorage.downloadImage(imageUrl: link) { (profileImage) in
                self.avatarImageView.image = profileImage!.circleMasked
            }
        }
        else {
            self.avatarImageView.image = UIImage(named: "avatar")!.circleMasked
        }
    }
}
