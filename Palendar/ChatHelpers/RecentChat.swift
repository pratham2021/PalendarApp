//  RecentChat.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/23/2021.

import Foundation
import Firebase

struct RecentChat: Codable {
    var id:String
    var chatRoomId:String
    var senderId:String
    var senderName:String
    var recieverId:String
    var recieverName:String
    var date:Date
    var memberIds:[String]
    var lastMessage:String
    var unreadCounter = 0
    var profilePictureLink:String
}
