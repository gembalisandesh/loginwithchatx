//
//  ViewController.swift
//  Pods
//
//  Created by Sandesh on 21/04/24.
//

import UIKit
import CometChatSDK

import CometChatCallsSDK
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none

        let message = messages[indexPath.row]
        let senderUID = CometChat.getLoggedInUser()?.uid
        let isSentByCurrentUser = message.senderUid == senderUID
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor(patternImage: UIImage(named: "ChatBackGround")!)

        tableView.backgroundView?.contentMode = .scaleAspectFill
       
        
        if isSentByCurrentUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
            cell.configureCell(with: message)
            cell.currentID = senderUID
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
            cell.configureCell(with: message)
            cell.currentID = senderUID
            cell.backgroundColor = .clear
            return cell
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == messageInputTextField {
            sendMessage()
            return true
        }
        return false
    }
}



extension ChatViewController {

    @objc func sendMessage() {
        guard let text = messageInputTextField.text, !text.isEmpty else {
            return
        }    
        let receiverID = recieverName
        sendTextMessage(to: receiverID, text: text)
        messageInputTextField.text = ""
       
        messageInputTextField.resignFirstResponder()
        scrollToBottom()
    }
    func scrollToBottom() {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }

    private func sendTextMessage(to receiverID: String, text: String) {
 
        
        let textMessage = TextMessage(receiverUid: receiverID, text: text, receiverType: .user)
        CometChat.sendTextMessage(message: textMessage, onSuccess: { [weak self] (message) in
            guard let self = self else { return }
            print("TextMessage sent successfully. " + message.stringValue())
            self.messages.append(message)
            
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
                self.scrollToBottom()
            }
        }) { (error) in
            print("TextMessage sending failed with error: " + error!.errorDescription)
        }
    }

}


extension ChatViewController: CometChatMessageDelegate {
    

  func onTextMessageReceived(textMessage: TextMessage) {

    print("TextMessage received successfully: " + textMessage.stringValue())
      self.messages.append(textMessage)
             DispatchQueue.main.async {
                 
                 self.messagesTableView.reloadData()
                 self.scrollToBottom()
             }
  }

  func onMediaMessageReceived(mediaMessage: MediaMessage) {

    print("MediaMessage received successfully: " + mediaMessage.stringValue())
  }
  
  func onCustomMessageReceived(customMessage: CustomMessage) {

    print("CustomMessage received successfully: " + customMessage.stringValue())
  }
}
extension UITableView {
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)
            
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
extension ChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            fetchMorePastMessages()
        }
    }
    
    private func fetchMorePastMessages() {
        guard let request = pastMessagesRequest else {
            print("PastMessagesRequest is nil")
            return
        }
        
        request.fetchPrevious(onSuccess: { [weak self] (messages) in
            guard let self = self else { return }
            if let messages = messages {
                self.messages.insert(contentsOf: messages, at: 0)
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                }
            }
        }) { (error) in
            print("Failed to fetch more past messages: \(error?.errorDescription ?? "Unknown error")")
        }
    }
}
//extension ChatViewController : CometChatCallDelegate {
//    func onIncomingCallCancelled(canceledCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
//        
//        print("Incoming Call Cancelled" + canceledCall!.stringValue())
//        guard let incomingCall = canceledCall else {
//            print("No incoming call to reject.")
//            return
//        }
//        
//        guard let sessionID = incomingCall.sessionID else {
//            print("Incoming call has no session ID.")
//            return
//        }
//        
//        CometChat.rejectCall(sessionID: sessionID, status: .cancelled, onSuccess: { (rejectedCall) in
//            if let call = rejectedCall {
//                print("Call cancelled successfully: \(call.stringValue())")
//                DispatchQueue.main.async {
//                    let callsViewController = self.presentedViewController as? CallsViewController
//                    callsViewController!.dismiss(animated: true, completion: nil)
//                }
//            } else {
//                print("Rejected call object is nil")
//            }
//        }) { (error) in
//            print("Call rejection failed with error: \(error?.errorDescription ?? "")")
//        }
//        
//    }
//    
//    func onIncomingCallReceived(incomingCall: Call?, error: CometChatException?) {
//        guard let incomingCall = incomingCall else {
//            print("Error receiving incoming call: \(error?.errorDescription ?? "Unknown error")")
//            return
//        }
//
//        let callsViewController = CallsViewController()
//        callsViewController.modalPresentationStyle = .fullScreen
//
//        callsViewController.senderID = incomingCall.sender?.uid ?? ""
//        callsViewController.usernameLabel.text = incomingCall.sender?.name
//
//        if let user = incomingCall.sender, let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: avatarURL), let image = UIImage(data: data) {
//                    DispatchQueue.main.async { [weak callsViewController] in
//                        callsViewController?.profileImageView.image = image
//                    }
//                } else {
//                    DispatchQueue.main.async { [weak callsViewController] in
//                        callsViewController?.profileImageView.image = UIImage(named: "default_avatar")
//                    }
//                }
//            }
//        } else {
//            callsViewController.profileImageView.image = UIImage(named: "default_avatar")
//        }
//
//        callsViewController.handleIncomingCall(incomingCall)
//
//        self.present(callsViewController, animated: true, completion: nil)
//    }
//
//    func onOutgoingCallAccepted(acceptedCall: Call?, error: CometChatException?) {
//        let callsViewController = CallsViewController()
//        guard let acceptedCall = acceptedCall else {
//                   print("Error accepting outgoing call: \(error?.errorDescription ?? "Unknown error")")
//                   return
//        }
//        print("Outgoing call accepted: \(acceptedCall.stringValue())")
//        generateTokenAndStartCall(for: acceptedCall)
//    }
//
//    func onOutgoingCallRejected(rejectedCall: Call?, error: CometChatException?) {
//        guard let rejectedCall = rejectedCall else {
//            print("No outgoing call to reject.")
//            return
//        }
//        
//        guard let sessionID = rejectedCall.sessionID else {
//            print("Outgoing call has no session ID.")
//            return
//        }
//        
//        CometChat.rejectCall(sessionID: sessionID, status: .rejected, onSuccess: { (rejectedCall) in
//            if let call = rejectedCall {
//                print("Call rejected successfully: \(call.stringValue())")
//                DispatchQueue.main.async {
////                    if let callsSenderViewController = self.presentedViewController as? CallsSenderViewController {
////                        callsSenderViewController.dismiss(animated: true, completion: nil)
////                    } else {
////                        self.dismiss(animated: true, completion: nil)
////                    }
//                    let callsSenderViewController = self.presentedViewController as? CallsSenderViewController
//                    callsSenderViewController!.dismiss(animated: true, completion: nil)
//                    
//                }
//            } else {
//                print("Rejected call object is nil")
//            }
//        }) { (error) in
//            print("Call rejection failed with error: \(error?.errorDescription ?? "")")
//        }
//    }
//    
//   
//    func onCallEndedMessageReceived(endedCall: Call?, error: CometChatException?) {
//        print(" Ended call " + endedCall!.stringValue())
//    }
//    private func generateTokenAndStartCall(for acceptedCall: Call) {
//           let sessionId = acceptedCall.sessionID!
//           let authToken = CometChat.getUserAuthToken() ?? ""
//           
//           CometChatCalls.generateToken(authToken: authToken as NSString, sessionID: sessionId as NSString) { [weak self] token in
//               guard let self = self else { return }
//               print("Token generated successfully: \(token)")
//               self.callToken = token
//               self.setupCallSettings()
//               DispatchQueue.main.async {
//                   self.startCallSession()
//               }
//           } onError: { error in
//               print("CometChatCalls generateToken error: \(String(describing: error?.errorDescription))")
//           }
//       }
//       
//       private func setupCallSettings() {
//           callSettings = CometChatCalls.callSettingsBuilder
//               .setDefaultLayout(true)
//               .setIsAudioOnly(false)
//               .setIsSingleMode(false)
//               .setShowSwitchToVideoCall(false)
//               .setEnableVideoTileClick(true)
//               .setEnableDraggableVideoTile(true)
//               .setEndCallButtonDisable(false)
//               .setShowRecordingButton(true)
//               .setSwitchCameraButtonDisable(false)
//               .setMuteAudioButtonDisable(false)
//               .setPauseVideoButtonDisable(false)
//               .setAudioModeButtonDisable(false)
//               .setStartAudioMuted(true)
//               .setStartVideoMuted(false)
//               .setMode("DEFAULT")
//               .setDefaultAudioMode("BLUETOOTH")
//               .setDelegate(self)
//               .build()
//       }
//       
//       private func startCallSession() {
//           guard let callToken = self.callToken, let callSettings = self.callSettings else { return }
//           
//           CometChatCalls.startSession(callToken: callToken, callSetting: callSettings, view: callRunningView) { success in
//               DispatchQueue.main.async {
//                   print("CometChatCalls startSession success: \(success)")
//                   self.setupCallRunningView()
//               }
//           } onError: { error in
//               DispatchQueue.main.async {
//                   print("CometChatCalls startSession error: \(String(describing: error?.errorDescription))")
//               }
//           }
//       }
//}
//extension ChatViewController : CallsEventsDelegate {
//    
//    func onCallEnded() {
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    func onCallEndButtonPressed() {
//        print("onCallEndButtonPressed")
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    func onUserJoined(user: NSDictionary) {
//        print("onUserJoined")
//    }
//    
//    func onUserLeft(user: NSDictionary) {
//        print("onUserLeft")
//    }
//    
//    func onUserListChanged(userList: NSArray) {
//        print("onUserListChanged")
//    }
//    
//    func onAudioModeChanged(audioModeList: NSArray) {
//        print("onAudioModeChanged")
//    }
//    
//    func onCallSwitchedToVideo(info: NSDictionary) {
//        print("onCallSwitchedToVideo")
//    }
//    
//    func onUserMuted(info: NSDictionary) {
//        print("onUserMuted")
//    }
//    
//    func onRecordingToggled(info: NSDictionary) {
//        print("onRecordingToggled")
//    }
//}
