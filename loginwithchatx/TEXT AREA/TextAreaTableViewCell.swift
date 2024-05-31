//
//  TextAreaTableViewCell.swift
//  loginwithchatx
//
//  Created by Sandesh on 18/04/24.
//
import UIKit
import CometChatSDK


class TextAreaTableViewCell: UITableViewCell {
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width/2
        
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()

    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private let unreadCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

//    private let lastReadMessageIdLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12)
//        label.textColor = .gray
//        return label
//    }()

    private let updatedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
            //avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0

        setupUI()
        //layoutIfNeeded()
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(unreadCountLabel)
        //contentView.addSubview(lastReadMessageIdLabel)
        contentView.addSubview(updatedAtLabel)

        let padding: CGFloat = 16.0

//        super.layoutSubviews()
//        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            //avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 6),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7)
        ])

        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            lastMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
        updatedAtLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            updatedAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            updatedAtLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 7),
            updatedAtLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100)
        ])

        unreadCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unreadCountLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 297),
            unreadCountLabel.topAnchor.constraint(equalTo: updatedAtLabel.bottomAnchor, constant: 1),
            
            unreadCountLabel.widthAnchor.constraint(equalToConstant: 24),
            unreadCountLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

//        //lastReadMessageIdLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            lastReadMessageIdLabel.leadingAnchor.constraint(equalTo: lastMessageLabel.leadingAnchor),
//            lastReadMessageIdLabel.topAnchor.constraint(equalTo: lastMessageLabel.bottomAnchor, constant: 8),
//            lastReadMessageIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
//        ])

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //separatorInset = UIEdgeInsets(top: 0.0, left: bounds.width, bottom: 0.0, right: 0.0)
                
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
    }

    private let maxCharInLastMessageLabel = 20
    func configure(with conversation: Conversation) {

        if let user = conversation.conversationWith as? User {
            usernameLabel.text = user.name ?? "Unknown User"
            if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: avatarURL) {
                        DispatchQueue.main.async { [weak self] in
                            self?.avatarImageView.image = UIImage(data: data)
                        }
                    }
                }
            } else {
                avatarImageView.image = nil
            }
        } else {
            usernameLabel.text = "Unknown User"
            avatarImageView.image = nil
        }

        if let lastMessage = conversation.lastMessage as? TextMessage {
            let lastMessageText = lastMessage.text
            if lastMessageText.isEmpty {
                lastMessageLabel.text = "No Messages"
            } else {
                let truncatedText: String
                if lastMessageText.count > maxCharInLastMessageLabel {
                    let index = lastMessageText.index(lastMessageText.startIndex, offsetBy: maxCharInLastMessageLabel)
                    truncatedText = String(lastMessageText[...index]) + "..."
                } else {
                    truncatedText = lastMessageText
                }
                lastMessageLabel.text = truncatedText
            }
        }
        unreadCountLabel.text = "\(conversation.unreadMessageCount)"
        
        unreadCountLabel.isHidden = conversation.unreadMessageCount == 0
        let updatedAtTimestamp = conversation.updatedAt
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter2.dateFormat = "dd MMM yyyy"
        //let currentDate = Date()
        
        let updatedAtDate = Date(timeIntervalSince1970: updatedAtTimestamp)
        //let updatedAtString = dateFormatter.string(from: updatedAtDate)
        //let updatedAtStringTwo = dateFormatter2.string(from: updatedAtDate)
        if Calendar.current.isDateInToday(updatedAtDate){
            updatedAtLabel.text = "\(dateFormatter.string(from: updatedAtDate))"
        } else if Calendar.current.isDateInYesterday(updatedAtDate){
            updatedAtLabel.text = "Yesterday"

        } else {
            updatedAtLabel.text = dateFormatter2.string(from: updatedAtDate)
        }
        

        //let updatedAtString = dateFormatter.string(from: updatedAtDate)
        //updatedAtLabel.text = "\(updatedAtString)"
    }
}
