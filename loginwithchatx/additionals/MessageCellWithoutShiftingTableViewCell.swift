//
//  MessageCellWithoutShiftingTableViewCell.swift
//  loginwithchatx
//
//  Created by Sandesh on 30/04/24.
//

import UIKit
import CometChatSDK

class MessageCellWithoutShiftingTableViewCell: UITableViewCell {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    private let messageBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.black.cgColor
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
    
    private let doubleTickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        let red: CGFloat = 104.0 / 255.0
        let green: CGFloat = 197.0 / 255.0
        let blue: CGFloat = 255.0 / 255.0
        let alpha: CGFloat = 1
        imageView.tintColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let doubleTickSecondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        let red: CGFloat = 104.0 / 255.0
        let green: CGFloat = 197.0 / 255.0
        let blue: CGFloat = 255.0 / 255.0
        let alpha: CGFloat = 1
        imageView.tintColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var doubleTickLeadingConstraint: NSLayoutConstraint!
    private var doubleTickSecondLeadingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
        messageBubbleView.addSubview(timestampLabel)
        messageBubbleView.addSubview(doubleTickImageView)
        messageBubbleView.addSubview(doubleTickSecondImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            messageBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            messageBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            messageBubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            messageBubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.bounds.width * 0.7) // Set maximum width for message bubble
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: messageBubbleView.bottomAnchor, constant: -12),
        ])
        
        timestampLeadingConstraint = timestampLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16)
        timestampLeadingConstraint.isActive = true
        
        timestampTrailingConstraint = timestampLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -29)
        timestampTrailingConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -2),
        ])
        
        doubleTickLeadingConstraint = doubleTickImageView.leadingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: 5)
        doubleTickLeadingConstraint.isActive = false
        
        doubleTickSecondLeadingConstraint = doubleTickSecondImageView.leadingAnchor.constraint(equalTo: doubleTickImageView.trailingAnchor, constant: 5)
        doubleTickSecondLeadingConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            doubleTickImageView.topAnchor.constraint(equalTo: timestampLabel.topAnchor),
            doubleTickImageView.trailingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: 15),
            doubleTickImageView.widthAnchor.constraint(equalToConstant: 15),
            doubleTickImageView.heightAnchor.constraint(equalToConstant: 15),
            
            doubleTickSecondImageView.topAnchor.constraint(equalTo: timestampLabel.topAnchor),
            doubleTickSecondImageView.trailingAnchor.constraint(equalTo: doubleTickImageView.trailingAnchor, constant: 4),
            doubleTickSecondImageView.widthAnchor.constraint(equalToConstant: 15),
            doubleTickSecondImageView.heightAnchor.constraint(equalToConstant: 15),
        ])
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any properties or UI elements to their default state
        messageLabel.text = nil
        timestampLabel.text = nil
        messageBubbleView.backgroundColor = .clear
        // Reset constraints if needed
        timestampLeadingConstraint.isActive = false
        timestampTrailingConstraint.isActive = false
        doubleTickLeadingConstraint.isActive = false
        doubleTickSecondLeadingConstraint.isActive = false
    }
    
    func configureCell(with message: BaseMessage) {
        if let textMessage = message as? TextMessage {
            messageLabel.text = textMessage.text
        } else {
            messageLabel.text = "Call"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(message.sentAt)))
        timestampLabel.text = timestampString

        let isSentByCurrentUser = message.senderUid == CometChat.getLoggedInUser()?.uid
        if isSentByCurrentUser {
            let red: CGFloat = 217.0 / 255.0
            let green: CGFloat = 245.0 / 255.0
            let blue: CGFloat = 205.0 / 255.0
            let alpha: CGFloat = 1
            messageBubbleView.backgroundColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)

            messageBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10).isActive = false
            messageBubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

            timestampLeadingConstraint.isActive = false
            timestampTrailingConstraint.isActive = true
            doubleTickLeadingConstraint.isActive = true
            doubleTickSecondLeadingConstraint.isActive = true
        } else {
            messageBubbleView.backgroundColor = .white

            messageBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10).isActive = true
            messageBubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = false

            timestampLeadingConstraint.isActive = true
            timestampTrailingConstraint.isActive = false
            doubleTickLeadingConstraint.isActive = false
            doubleTickSecondLeadingConstraint.isActive = false
        }
    }
}
