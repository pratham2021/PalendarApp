//  StartChat.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/28/2021.

import Foundation
import Firebase

class StartChat {
    
    let uniqueString = UserManager.getUser("userId") as? String
    
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = chatRoomIdFrom(user1Id: user1.docID, user2Id: user2.docID)
        createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
        return chatRoomId
    }

    func createRecentItems(chatRoomId:String, users:[User]) {
        
        var memberIdsToCreateRecent = [users.first!.docID, users.last!.docID]
        
        // does user have a recent?
        let database = Firestore.firestore()
        database.collection("recent").whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
            if snapshot != nil && error == nil {
                if !snapshot!.isEmpty {
                    memberIdsToCreateRecent = self.removeMemberWhoHasRecent(snapshot: snapshot!, memberIds: memberIdsToCreateRecent)
                }
                
                for userId in memberIdsToCreateRecent {
                    
                    let senderUser = userId == self.uniqueString! ? self.getCurrentUserObject(): self.getReceiverFrom(users: users)
                    
                    let recieverUser = userId == self.uniqueString! ? self.getReceiverFrom(users: users):self.getCurrentUserObject()
                    
                    let recentObject = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.docID, senderName: senderUser.fullName, recieverId: recieverUser.docID, recieverName: recieverUser.fullName, date: Date(), memberIds: [senderUser.docID, recieverUser.docID], lastMessage: "", unreadCounter: 0, profilePictureLink: recieverUser.profilePictureUrl!)
                    
                    RecentListener.shared.addRecent(recentObject)
                }
            }
        }
    }
    
    func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
        var memberIdsToCreateRecent = memberIds
        
        for recentData in snapshot.documents {
            let currentRecent = recentData.data()
            
            if let currentUserId = currentRecent["senderId"] {
                if memberIdsToCreateRecent.contains(currentUserId as! String) {
                    memberIdsToCreateRecent.remove(at: Int(memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!))
                    
                }
            }
        }
        return memberIdsToCreateRecent
    }

    func chatRoomIdFrom(user1Id:String, user2Id:String) -> String {
        var chatRoomId = ""
        let value = user1Id.compare(user2Id).rawValue
        chatRoomId = value < 0 ? (user1Id + user2Id):(user2Id + user1Id)
        return chatRoomId
    }
    
    func getReceiverFrom(users:[User]) -> User {
        var allUsers = users
        
        allUsers.removeAll { (user) in
            user.docID == uniqueString!
        }
        
        return allUsers.first!
    }
    
    func getCurrentUserObject() -> User {
        
        let database = Firestore.firestore()
        
        var user:User?
        
        database.collection("users").document(uniqueString!).getDocument { (snap, error) in
            
            if snap != nil && error == nil {
                
                let data = snap!.data()!
                
                let firstName = data["firstname"] as! String
                let lastName = data["lastname"] as! String
                let phoneNumber = data["phoneNumber"] as! String
                let docId = self.uniqueString!
                let age = data["age"] as! String
                let INTERESTS = data["interests"] as? [String]
                let from = data["from"] as? [String]
                let to = data["to"] as? [String]
                let timeOfDay = data["timeOfDay"] as? String
                let email = data["email"] as! String
                let profilePictureUrl = data["profilePictureUrl"] as? String
                let fullName = data["fullName"] as! String
                let active = data["isActive"] as! Bool
                
                DispatchQueue.main.async {
                    user = User(firstname: firstName, lastname: lastName, phoneNumber: phoneNumber, docID: docId, age: age, interests: INTERESTS!, from: from!, to: to!, timeOfDay: timeOfDay!, email: email, profilePictureUrl: profilePictureUrl!, fullName: fullName, isActive: active)
                }
            }
        }
        
        return user!
    }
    
}
