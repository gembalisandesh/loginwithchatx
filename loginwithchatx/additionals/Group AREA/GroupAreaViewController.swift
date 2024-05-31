////
////  GroupAreaViewController.swift
////  loginwithchatx
////
////  Created by Sandesh on 22/04/24.
////
//
//import UIKit
//import CometChatSDK
//
//class GroupAreaViewController: UIViewController, UITableViewDelegate{
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    
//
//    override func viewWillAppear(_ animated: Bool) {
//        let cometChatGroupsWithMessages = CometChatGroupsWithMessages()
////        let naviVC = UINavigationController(rootViewController: cometChatConversationsWithMessages)
//        self.navigationController?.pushViewController(cometChatGroupsWithMessages, animated: true)
//        
//    }
//    
////    var groupName : String = ""
////    var lastScene : String = ""
////    var messagesNextRequest: MessagesRequest?
////    var gUID = String()
////    var profileIcon: UIImage?
////    var gName: String?
////    var extracteddata: [Conversation] = []
////    var messages: [BaseMessage] = []
////    var pastMessagesRequest: MessagesRequest?
////    var lastSceneUpdatedAt: Double?
////    var conversationType : String?
////    var groupConversations: [Conversation] = []
////    private let groupRequest = ConversationRequest.ConversationRequestBuilder(limit: 20)
////        .setConversationType(conversationType: .group)
////        .build
////    
////    private let tableView: UITableView = {
////            let tableView = UITableView()
////            // Additional setup if needed
////            return tableView
////        }()
////    private let noConversationLabel: UILabel = {
////        let label = UILabel()
////        label.text = "NO CONVERSATION"
////        label.textAlignment = .center
////        label.font = .systemFont(ofSize: 30, weight: .medium)
////        label.isHidden = true
////        return label
////    }()
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////        view.addSubview(tableView)
////        view.addSubview(noConversationLabel) // Add noConversationLabel as a subview
////        
////        tableView.delegate = self
////        tableView.dataSource = self
////        
////        // Set up constraints for tableView
////        tableView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            tableView.topAnchor.constraint(equalTo: view.topAnchor),
////            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
////        ])
////        
////        // Set up constraints for noConversationLabel
////        noConversationLabel.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            noConversationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            noConversationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
////        ])
////        
////        noConversationLabel.isHidden = true
////        
////       fetchGroupConversations()
////        // Do any additional setup after loading the view.
////    }
////    override func viewWillAppear(_ animated: Bool) {
////        //fetchGroupConversations()
////    }
////
////    private func fetchGroupConversations() {
////        groupRequest().fetchNext(onSuccess: { [weak self] (conversationList) in
////            
////            self?.groupConversations = conversationList.compactMap { conversation in
////                guard let conversationId = conversation.conversationId,
////                      let lastMessage = conversation.lastMessage,
////                      let conversationWith = conversation.conversationWith else {
////                    
////                    print("Error: Essential properties are missing for conversation \(conversation.conversationId ?? "")")
////                    
////                    return nil
////                }
////                
////                let conversationType = conversation.conversationType
////                let unreadMessageCount = conversation.unreadMessageCount
////                let updatedAt = conversation.updatedAt
////                let tags = conversation.tags ?? []
////                let unreadMentionsCount = conversation.unreadMentionsCount
////                let lastReadMessageId = conversation.lastReadMessageId
////                
////                print("Conversation Id: \(conversationId)")
////                print("Conversation Type: \(conversationType)")
////                print("Unread Message Count: \(unreadMessageCount)")
////                print("Updated At: \(updatedAt)")
////                print("Tags: \(tags)")
////                print("Unread Mentions Count: \(unreadMentionsCount)")
////                print("Last Read Message Id: \(lastReadMessageId)")
////                
////                return conversation
////            }
////            
////            DispatchQueue.main.async {
////                self?.tableView.reloadData()
////                self?.noConversationLabel.isHidden = !(self?.groupConversations.isEmpty ?? true)
////            }
////        }) { (exception) in
////            if let errorDescription = exception?.errorDescription {
////                print("Error: \(errorDescription)")
////            }
////        }
////    }
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////            return groupConversations.count
////        }
////
////        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextAreaTableViewCell", for: indexPath) as? TextAreaTableViewCell else {
////                return UITableViewCell()
////            }
////            let conversation = groupConversations[indexPath.row]
////            cell.configure(with: conversation)
////            return cell
////        }
////
////        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////            
////        }
//
//}
