//  HangOutCollectionCell.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/11/2021.

import UIKit

class HangOutCollectionCell: UICollectionViewCell {
    
    @IBOutlet var hangOutCardView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var availablityLabel: UILabel!
    @IBOutlet var interestslabel: UILabel!
    
    var user: User? = nil {
        didSet {
            if user != nil {
                hangOutCardView.backgroundColor = .systemTeal
                hangOutCardView.layer.cornerRadius = 15
                nameLabel.text = user!.firstname + " " + user!.lastname
                availablityLabel.text = user!.from![0] + " " + user!.from![1] + " - " + user!.to![0] + " " + user!.to![1]
                interestslabel.text = user!.interests[0] + ", " + user!.interests[1] + ", " + user!.interests[2]
            }
        }
    }
    
    var number:Int? = nil {
        didSet {
            if number != nil {
                switch number! {
                    case 0:
                        hangOutCardView.backgroundColor = .systemTeal
                        nameLabel.textColor = .black
                        availablityLabel.textColor = .black
                        availablityLabel.textColor = .black
                    case 1:
                        hangOutCardView.backgroundColor = .systemBlue // .blue
                        nameLabel.textColor = .black
                        availablityLabel.textColor = .black
                        availablityLabel.textColor = .black
                    case 2:
                        hangOutCardView.backgroundColor = .orange 
                        nameLabel.textColor = .black
                        availablityLabel.textColor = .black
                        availablityLabel.textColor = .black
                    case 3:
                        hangOutCardView.backgroundColor = .systemPurple
                        nameLabel.textColor = .white
                        availablityLabel.textColor = .white
                        availablityLabel.textColor = .white
                    default:
                        break
                }
            }
        }
    }
    
}
