//
//  TextAreaViewController.swift
//  loginwithchatx
//
//  Created by Sandesh on 18/04/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK


class TextAreaViewController: UIViewController {
    
    
    var conversations: [Conversation] = []
    var groupConversations: [Conversation] = []
    
    var callToken: String?
    var callSettings: CometChatCallsSDK.CallSettings?
    

    private var selectedIndexPath: IndexPath?
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()

    private var selectedConversation: Conversation?
    var expandedCells: [IndexPath: Bool] = [:]

    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "NO CONVERSATION"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    var uid = ""


    private let chatsLabel : UILabel = {
        let chat = UILabel()
        chat.text = "Chats"
        chat.font = UIFont.boldSystemFont(ofSize: 24)
        chat.translatesAutoresizingMaskIntoConstraints = false

        return chat
    }()
    private lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        return button
    }()
    private let convRequest = ConversationRequest.ConversationRequestBuilder(limit: 20)
                                    .setConversationType(conversationType: .user)
                                    .build()
//    private let groupRequest = ConversationRequest.ConversationRequestBuilder(limit: 20)
//        .setConversationType(conversationType: .group)
//        .build

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        //title = "LoginWithChatX"
        
        setupUI()
        fetchConversations()
//        CometChat.calldelegate = self
//        CometChat.addCallListener("abc", self)
        
       
        tableView.register(TextAreaTableViewCell.self, forCellReuseIdentifier: "TextAreaTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
    }
    private func fetchConversations() {
            fetchUserConversations()
           // fetchGroupConversations()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        //let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [flexibleSpace, flexibleSpace, flexibleSpace,logoutButton]
//        if let navigationHeight = navigationController?.navigationBar.frame.height{
//            logoutButton.frame = CGRect(x: 0, y:80, width: 80, height: 50)
//        }
        title = "Chats"
        
        //view.addSubview(chatsLabel)
    
        view.addSubview(tableView)
        view.addSubview(noConversationLabel)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        noConversationLabel.translatesAutoresizingMaskIntoConstraints = false
        //logoutButton.translatesAutoresizingMaskIntoConstraints = false
        chatsLabel.translatesAutoresizingMaskIntoConstraints = false

        

        NSLayoutConstraint.activate([


            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            noConversationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noConversationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        noConversationLabel.isHidden = true
    }


    

    @objc func logoutButtonPressed() {
        CometChat.logout(onSuccess: { (response) in
            print("Logout successful.")
            DispatchQueue.main.async {
                CometChatNotifications.unregisterPushToken { success in
                    print("unregisterPushToken: \(success)")
                } onError: { error in
                    print("unregisterPushToken: \(error.errorCode) \(error.errorDescription)")
                }
                let loginViewController = LoginViewController()
                self.navigationController?.pushViewController(loginViewController, animated: false)
                loginViewController.navigationItem.setHidesBackButton(true, animated: false)

            }
        }) { (error) in
            print("Logout failed with error: " + error.errorDescription)
        }
    }


    
    var conversationsWithUnreadMessages: [CometChatSDK.Conversation] = []

    private func fetchUserConversations() {
        self.conversations.removeAll()
        convRequest.fetchNext(onSuccess: { [weak self] (conversationList) in
           
            self?.conversations = conversationList.compactMap { conversation in
                guard let conversationId = conversation.conversationId,
                      let lastMessage = conversation.lastMessage,
                      let conversationWith = conversation.conversationWith else {
                   
                    print("Error: Essential properties are missing for conversation \(conversation.conversationId ?? "")")
                   
                    return  nil
                }
                
                let conversationType = conversation.conversationType
                let unreadMessageCount = conversation.unreadMessageCount
                let updatedAt = conversation.updatedAt
                let tags = conversation.tags ?? []
                let unreadMentionsCount = conversation.unreadMentionsCount
                let lastReadMessageId = conversation.lastReadMessageId
                
                
                
               
                print("Conversation Id: \(conversationId)")
                print("Conversation Type: \(conversationType)")
                print("Unread Message Count: \(unreadMessageCount)")
                print("Updated At: \(updatedAt)")
                print("Tags: \(tags)")
                print("Unread Mentions Count: \(unreadMentionsCount)")
                print("Last Read Message Id: \(String(describing: lastReadMessageId))")
                
                if unreadMessageCount > 0 {
                    self?.conversationsWithUnreadMessages.append(conversation)
                }
               
                return conversation
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.noConversationLabel.isHidden = !(self?.conversations.isEmpty ?? true)
            }
        }) { (exception) in
          
            if let errorDescription = exception?.errorDescription {
                print("Error: \(errorDescription)")
               
            }
        }
    }
}



