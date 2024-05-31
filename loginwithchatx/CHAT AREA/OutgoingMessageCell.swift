//
//  OutgoingMessageCell.swift
//  loginwithchatx
//
//  Created by Sandesh on 01/05/24.
//
import UIKit
import CometChatSDK

class OutgoingMessageCell: UITableViewCell {
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
        view.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 245.0 / 255.0, blue: 205.0 / 255.0, alpha: 1)
        view.layer.cornerRadius = 18
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
    private let checkmarkScale: CGFloat = 0.82
    private let doubleTickFirstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = UIColor(displayP3Red: 104.0 / 255.0, green: 197.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let doubleTickSecondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = UIColor(displayP3Red: 104.0 / 255.0, green: 197.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        contentView.addSubview(doubleTickFirstImageView)
        contentView.addSubview(doubleTickSecondImageView)
        
        doubleTickFirstImageView.transform = CGAffineTransform(scaleX: checkmarkScale, y: checkmarkScale)
        doubleTickSecondImageView.transform = CGAffineTransform(scaleX: checkmarkScale, y: checkmarkScale)

        NSLayoutConstraint.activate([
            messageBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            messageBubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            messageBubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            messageBubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 270)

        ])
      
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: timestampLabel.topAnchor, constant: -2), // Adjust bottom constraint to be relative to timestampLabel
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -16)
        ])
  
        NSLayoutConstraint.activate([
            timestampLabel.leadingAnchor.constraint(equalTo: doubleTickSecondImageView.trailingAnchor, constant: -74),
            timestampLabel.bottomAnchor.constraint(equalTo: messageBubbleView.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            doubleTickFirstImageView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            doubleTickFirstImageView.trailingAnchor.constraint(equalTo: doubleTickSecondImageView.leadingAnchor, constant: 14),
            
            doubleTickSecondImageView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            doubleTickSecondImageView.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -4)
        ])
        
       
        let minimumBubbleWidth = max(timestampLabel.frame.maxX, doubleTickSecondImageView.frame.maxX) + 8
        messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumBubbleWidth).isActive = true
    }

    
    func configureCell(with message: BaseMessage) {
        if let textMessage = message as? TextMessage {
            messageLabel.text = textMessage.text
        } else if let call = message as? Call {
            if call.sender?.uid == currentID {
                messageLabel.text = "You called"
            }else{
                messageLabel.text = "You have been called"
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timestampString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(message.sentAt)))
        timestampLabel.text = timestampString
    }
}
