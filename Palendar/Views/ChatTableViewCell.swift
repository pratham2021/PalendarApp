//  ChatTableViewCell.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/21/2021.

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func decorateCell(_ user:User) {
        userNameLabel.text = user.firstname + " " + user.lastname
        statusLabel.text = user.isActive ? "Active now":"Offline"
        statusLabel.textColor = user.isActive ? .systemGreen:.black
        if user.profilePictureUrl != nil {
            let fileStorage = FileStorage()
            DispatchQueue.main.async {
                fileStorage.downloadImage(imageUrl: user.profilePictureUrl!) { (image) in
                    DispatchQueue.main.async {
                        if image != nil {
                            self.profileImage.image = image!.circleMasked
                        }
                    }
                }
            }
        }
        else {
            self.profileImage.image = UIImage(named: "avatar")!
        }
    }
}

