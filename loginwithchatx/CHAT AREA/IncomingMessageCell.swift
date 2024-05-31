//
//  IncomingMessageCell.swift
//  loginwithchatx
//
//  Created by Sandesh on 01/05/24.
//

import UIKit
import CometChatSDK

class IncomingMessageCell: UITableViewCell {
    var currentID : String?
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    private let messageBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timestampLeadingConstraint: NSLayoutConstraint!
    private var timestampTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
            contentView.addSubview(messageBubbleView)
            messageBubbleView.addSubview(messageLabel)
            messageBubbleView.addSubview(timestampLabel)

            NSLayoutConstraint.activate([
                messageBubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                messageBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60),
                messageBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
                messageBubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                messageBubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
                messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: timestampLabel.topAnchor, constant: -2),
                messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -16),
            ])


            NSLayoutConstraint.activate([
                timestampLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -8),
                timestampLabel.bottomAnchor.constraint(equalTo: messageBubbleView.bottomAnchor, constant: -4)
            ])
        }
    
    
    func configureCell(with message: BaseMessage) {
        if let textMessage = message as? TextMessage {
            messageLabel.text = textMessage.text
        } else if let call = message as? Call {
            if call.sender?.uid == currentID {
                messageLabel.text = "You have been Called"
            }else{
                messageLabel.text = "You Called"
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(message.sentAt)))
        timestampLabel.text = timestampString
    }
}
