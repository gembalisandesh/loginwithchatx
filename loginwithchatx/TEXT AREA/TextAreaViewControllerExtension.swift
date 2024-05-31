//
//  TextAreaViewControllerExtension.swift
//  loginwithchatx
//
//  Created by Sandesh on 23/04/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

extension TextAreaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextAreaTableViewCell", for: indexPath) as? TextAreaTableViewCell else {
            return UITableViewCell()
        }
        tableView.separatorStyle = .singleLine
        let conversation = conversations[indexPath.row]
        cell.configure(with: conversation)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        let chatViewController = ChatViewController()
        
       // let groupViewController = GroupAreaViewController()
        
        if let user = conversation.conversationWith as? User, let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {

               DispatchQueue.main.async {
                   if let data = try? Data(contentsOf: avatarURL), let image = UIImage(data: data) {
                       DispatchQueue.main.async { [weak chatViewController] in
                           chatViewController?.profileImageView.image = image
                       }
                   }
               }
           } else {
               chatViewController.profileImageView.image = UIImage(named: "default_avatar")
           }
        if let user = conversation.conversationWith as? User {
            chatViewController.profileName = user.name ?? ""
        } else {
            chatViewController.profileName = "Unknown User"
        }
        
        if let user = conversation.conversationWith as? User {
            chatViewController.recieverName = user.uid ?? ""
        } else {
            chatViewController.recieverName = "Unknown UID"
        }
        if let user = conversation.conversationWith as? User {
            chatViewController.MessagerUID = user.uid ?? ""
            //print("Sandesh \(user.uid!)")
            //conversation.unreadMessageCount = 0
        } else {
            chatViewController.MessagerUID = "Unknown UID"
        }
        if let receiverUID = (conversation.conversationWith as? CometChatSDK.User)?.uid {
            
            chatViewController.receiverID = receiverUID
        } else {
            chatViewController.receiverID = "Unknown UID"
        }

        chatViewController.unreadMessageCount = conversationsWithUnreadMessages.count
                
        chatViewController.lastSceneUpdatedAt = conversation.updatedAt
//        if let user = conversation.conversationWith as? User {
//            conversation.unreadMessageCount = 0
//        }
        chatViewController.modalPresentationStyle = .fullScreen
        present(chatViewController, animated: false, completion: nil)
        //navigationController?.pushViewController(chatViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 72
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let headerView = UIView()
//            headerView.backgroundColor = .clear
//            return headerView
//        }
}

