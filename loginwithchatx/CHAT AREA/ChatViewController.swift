//
//  ChatViewController.swift
//  loginwithchatx
//
//  Created by Sandesh on 20/04/24.
//
import UIKit
import CometChatSDK
import CometChatCallsSDK

class ChatViewController: UIViewController, UITableViewDelegate{
    
    
    var recieverName : String = ""
    var lastScene : String = ""
    var messagesNextRequest: MessagesRequest?
    var MessagerUID = String()
    var profileImage: UIImage?
    var profileName: String?
    var extracteddata: [Conversation] = []
    var messages: [BaseMessage] = []
    var pastMessagesRequest: MessagesRequest?
    var lastSceneUpdatedAt: Double?
    var conversationType : String?
    let textAreaViewController = TextAreaViewController()
    var unreadMessageCount: Int
    var receiverID: String = ""
    var callToken: String?
    var callSettings: CometChatCallsSDK.CallSettings?
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Send", for: .normal)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.tintColor = .black
        
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    var callingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = .black
        return button
    }()
    
    var videoCallingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "video"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(videoCallButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    private let unreadMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Helvetica", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let lastSceneLabel: UILabel = {
        let label = UILabel()
        label.text = "LastScene"
        label.font = UIFont(name: "Helvetica", size: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(IncomingMessageCell.self, forCellReuseIdentifier: "IncomingMessageCell")
        tableView.register(OutgoingMessageCell.self, forCellReuseIdentifier: "OutgoingMessageCell")

        return tableView
    }()

    
    private let messageInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageInputTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 20.0
        return textField
    }()
    
    
    private let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let stickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "app.badge"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let voiceRecorderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isEmojiKeyboardVisible = false
    
    var userloggedin : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let red: CGFloat = 244.0 / 255.0
        let green: CGFloat = 244.0 / 255.0
        let blue: CGFloat = 244.0 / 255.0
        let alpha: CGFloat = 1
        view.backgroundColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)

        messageInputView.backgroundColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        userloggedin = CometChat.getLoggedInUser()
        //setupBackground()
        setupUI()
        setupConstraints()
        messageInputTextField.becomeFirstResponder()
        lastSceneAT()
        CometChat.addMessageListener("xyz", self)

//        CometChat.addCallListener("abc", self)
        let profileImageSize: CGFloat = 45
        profileImageView.frame = CGRect(x: 0, y: 0, width: profileImageSize, height: profileImageSize)
        profileImageView.layer.cornerRadius = profileImageSize / 2
        profileImageView.layer.masksToBounds = true
        //backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        callingButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
//        videoCallingButton.addTarget(self, action: #selector(videoCallButtonTapped), for: .touchUpInside)
        print("Reciever \(receiverID)")

        messagesTableView.register(OutgoingMessageCell.self, forCellReuseIdentifier: "OutgoingMessageCell")
        messagesTableView.register(IncomingMessageCell.self, forCellReuseIdentifier: "IncomingMessageCell")
//      CometChat.calldelegate = self
        
       
    }
    
    
    func lastSceneAT() {
        if let lastSceneUpdatedAt = lastSceneUpdatedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Date()
            let currenntDateString = dateFormatter.string(from: currentDate)
            let lastSceneDateString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(lastSceneUpdatedAt)))
            if currenntDateString == lastSceneDateString{
                dateFormatter.dateFormat = "hh:mm a"
                let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(lastSceneUpdatedAt)))
                lastSceneLabel.text = "Last seen today at \(timestampString)"
            } else {
                if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
                {
                    let yesterdayDateString = dateFormatter.string(from: yesterday)
                    if yesterdayDateString ==  lastSceneDateString{
                        dateFormatter.dateFormat = "h:mm a"
                        let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: lastSceneUpdatedAt))
                        lastSceneLabel.text = "Yesterday at \(timestampString)"
                        return
                    }
                }
                dateFormatter.dateFormat = "MM dd, hh:mm a"
                let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(lastSceneUpdatedAt)))
                lastSceneLabel.text = "Last Scene at: \(timestampString)"
            }
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.messagesNextRequest = MessagesRequest.MessageRequestBuilder()
            .set(limit: 30)
            .set(uid: MessagerUID)
            .build()
        self.pastMessagesRequest = MessagesRequest.MessageRequestBuilder()
            .set(limit: 30)
            .set(uid: MessagerUID)
            .build()
        unreadcount()
        fetchPastMessages()
        messageFetchNext()
    }

 
    public init(unreadMessageCount: Int = 0) {
        self.unreadMessageCount = unreadMessageCount
        super.init(nibName: nil, bundle: nil)
    }


    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(messagesTableView)
        view.addSubview(messageInputView)
        view.addSubview(lastSceneLabel)
        view.addSubview(callingButton)
        view.addSubview(videoCallingButton)
        view.addSubview(searchButton)
        view.addSubview(unreadMessageLabel)
        
        messageInputView.addSubview(messageInputTextField)
        messageInputView.addSubview(emojiButton)
        messageInputView.addSubview(stickerButton)
        messageInputView.addSubview(cameraButton)
        messageInputView.addSubview(voiceRecorderButton)
        messageInputView.addSubview(sendButton)
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messageInputView.isUserInteractionEnabled = true
        messageInputTextField.rightView = stickerButton
        messageInputTextField.rightViewMode = .always
        unreadMessageLabel.text = String(unreadMessageCount)
        profileImageView.image = profileImage
        usernameLabel.text = profileName
        callingButton.isUserInteractionEnabled = true
        videoCallingButton.isUserInteractionEnabled = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: messageInputTextField.frame.height))
        messageInputTextField.leftView = rightPaddingView
        messageInputTextField.leftViewMode = .always
    }
    private func setupConstraints() {
            let safeArea = view.safeAreaLayoutGuide

            view.isUserInteractionEnabled = true
            NSLayoutConstraint.activate([
                backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 81.5),
                backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
                backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -385),
                unreadMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 94),
                unreadMessageLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -22),
                unreadMessageLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20),
                
                profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
                profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                
                profileImageView.widthAnchor.constraint(equalToConstant: 45),
                profileImageView.heightAnchor.constraint(equalToConstant: 45),

                usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
                usernameLabel.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -326),

                videoCallingButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 230),
                videoCallingButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                videoCallingButton.widthAnchor.constraint(equalToConstant: 50),
                videoCallingButton.heightAnchor.constraint(equalToConstant: 50),

                callingButton.leadingAnchor.constraint(equalTo: videoCallingButton.leadingAnchor, constant: 55),
                callingButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                callingButton.widthAnchor.constraint(equalToConstant: 50),
                callingButton.heightAnchor.constraint(equalToConstant: 50),
                
                searchButton.leadingAnchor.constraint(equalTo: callingButton.leadingAnchor, constant: 55),
                searchButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                searchButton.widthAnchor.constraint(equalToConstant: 30),
                searchButton.heightAnchor.constraint(equalToConstant: 30),

                lastSceneLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
                lastSceneLabel.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -326),

                messagesTableView.topAnchor.constraint(equalTo: lastSceneLabel.bottomAnchor, constant: 16),
                messagesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
                messagesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
                messagesTableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor, constant: -5),

                messageInputView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
                messageInputView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
                messageInputView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
                messageInputView.heightAnchor.constraint(equalToConstant: 60),

                messageInputTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 33),
                messageInputTextField.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                messageInputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -90),
                messageInputTextField.heightAnchor.constraint(equalToConstant: 35),
                
                stickerButton.trailingAnchor.constraint(equalTo: messageInputTextField.trailingAnchor, constant: -30),
                stickerButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                stickerButton.widthAnchor.constraint(equalToConstant: 37),
                stickerButton.heightAnchor.constraint(equalToConstant: 37),

                emojiButton.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: -4),
                emojiButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                emojiButton.widthAnchor.constraint(equalToConstant: 40),
                emojiButton.heightAnchor.constraint(equalToConstant: 40),
            
                cameraButton.trailingAnchor.constraint(equalTo: voiceRecorderButton.leadingAnchor, constant: -8),
                cameraButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                cameraButton.widthAnchor.constraint(equalToConstant: 40),
                cameraButton.heightAnchor.constraint(equalToConstant: 40),

                voiceRecorderButton.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 5),
                voiceRecorderButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                voiceRecorderButton.widthAnchor.constraint(equalToConstant: 40),
                voiceRecorderButton.heightAnchor.constraint(equalToConstant: 40),

                sendButton.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -10),
                sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
                sendButton.widthAnchor.constraint(equalToConstant: 50),
            ])
        }
    
    @objc private func backButtonTapped() {
        let navigationController = UINavigationController(rootViewController: textAreaViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
    }


    @objc private func callButtonTapped() {
        let receiverID = receiverID
        let receiverType: CometChat.ReceiverType = .user
        let callType: CometChat.CallType = .audio

        let newCall = Call(receiverId: receiverID, callType: callType, receiverType: receiverType)

        CometChat.initiateCall(call: newCall, onSuccess: { (ongoing_call) in
            print("Call initiated successfully " + ongoing_call!.stringValue())

            DispatchQueue.main.async {
                let callsSenderVC = CallsSenderViewController()
                callsSenderVC.receiverID = receiverID
                if let receiverImage = self.profileImageView.image {
                    callsSenderVC.receiverImage = receiverImage
                }
                callsSenderVC.outGoingCall = ongoing_call

                let navigationController = UINavigationController(rootViewController: callsSenderVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true) {
                    navigationController.topViewController?.navigationItem.setHidesBackButton(true, animated: false)
                }
            }
        }) { (error) in
            print("Call initialization failed with error:  " + error!.errorDescription)
        }
    }



    @objc private func videoCallButtonTapped() {
        let receiverID = receiverID
        let receiverType:CometChat.ReceiverType = .user
        let callType: CometChat.CallType = .video

        let newCall = Call(receiverId: receiverID, callType: callType, receiverType: receiverType);

        CometChat.initiateCall(call: newCall, onSuccess: { (ongoing_call) in

          print("Video Call initiated successfully " + ongoing_call!.stringValue());
            DispatchQueue.main.async {
                let callsSenderVC = CallsSenderViewController()
                callsSenderVC.receiverID = receiverID
                if let receiverImage = self.profileImageView.image {
                    callsSenderVC.receiverImage = receiverImage
                }
                callsSenderVC.outGoingCall = ongoing_call

                let navigationController = UINavigationController(rootViewController: callsSenderVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true) {
                    navigationController.topViewController?.navigationItem.setHidesBackButton(true, animated: false)
                }
            }
        }) { (error) in

          print("Video Call initialization failed with error:  " + error!.errorDescription);

        }
    }

    func fetchPastMessages() {
        self.messages.removeAll()
        guard let request = pastMessagesRequest else {
            print("pastMessagesRequest is nil")
            return
        }
        request.fetchPrevious(onSuccess: { [weak self] (messages) in
            guard let self = self else { return }
            if let messages = messages {
                self.messages = messages
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                    self.messagesTableView.scrollToBottom()
                }
            }
        }) { (error) in
            print("Failed to fetch past messages: \(error?.errorDescription ?? "Unknown error")")
        }
    }
    private func unreadcount() {
        
        let UID = MessagerUID
        CometChat.getUnreadMessageCountForUser(UID, onSuccess: { (response) in
            
            print("Unread count for users: \(response)")
            
        }) { (error) in
            
            print("Error in unread count for users: \(error)")
        }
    }

    func messageFetchNext() {
        guard let request = pastMessagesRequest else {
            print("NextMessagesRequest is nil")
            return
        }
        
        request.fetchNext(onSuccess: { [weak self] (messages) in
            guard let self = self else { return }
            if let messages = messages {
                
                self.messages = messages
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                }
            }
        }) { (error) in
            print("Failed to fetch next messages: \(error?.errorDescription ?? "Unknown error")")
        }
    }
}
