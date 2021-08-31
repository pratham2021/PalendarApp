//
//  RecentListener.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/28/21.
//

import Foundation
import Firebase

class RecentListener {
    
    static let shared = RecentListener()
    
    func addRecent(_ recent:RecentChat) {
        let database = Firestore.firestore()
        database.collection("recent").document(recent.id).updateData(["id":recent.id, "chatRoomId":recent.chatRoomId, "senderId":recent.senderId, "senderName":recent.senderName, "recieverId":recent.recieverId, "recieverName":recent.recieverName, "date":recent.date, "memberIds":recent.memberIds, "lastMessage":recent.lastMessage, "unreadCounter":recent.unreadCounter, "profilePictureLink":recent.profilePictureLink]) { (error) in
            if error == nil {
                print("SUCCESS SAVING RECENT CHAT!")
            }
        }
        
    }
    
}
