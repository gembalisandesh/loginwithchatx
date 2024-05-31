//
//  CallsSenderViewController.swift
//  loginwithchatx
//
//  Created by Sandesh on 24/05/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class CallsSenderViewController: UIViewController {
    
    var receiverID: String?
    var receiverName: String?
    var receiverImage: UIImage?
    var outGoingCall: Call?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var callStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Calling.."
        label.font = UIFont(name: "Helvetica", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone.down.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = .red
        button.imageView?.sizeToFit()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isUserInteractionEnabled = true
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        setupUI()
    }
    
    func setupUI() {
        
        
        view.backgroundColor = .white
        
        
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(callStatusLabel)
        view.addSubview(rejectButton)
        
        profileImageView.image = receiverImage
        //usernameLabel.text = receiverName ?? "Username"
        rejectButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            callStatusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            callStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rejectButton.topAnchor.constraint(equalTo: callStatusLabel.bottomAnchor, constant: 520),
            rejectButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 60),
            rejectButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        if let receiverID = receiverID {
            Helpers.getUser(forUID: receiverID) { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.usernameLabel.text = user?.name
                    if let receiverImage = self.receiverImage {
                        self.profileImageView.image = receiverImage
                    }
                }
            }
        }
    }
    
    
    
    
    @objc func cancelButtonTapped() {
        print("Cancel button tapped")
        guard let outGoingCall = self.outGoingCall else {
            print("No outgoing call to reject.")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let sessionID = outGoingCall.sessionID else {
            print("Outgoing call has no session ID.")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        CometChat.rejectCall(sessionID: sessionID, status: .cancelled, onSuccess: { (rejectedCall) in
            if let call = rejectedCall {
                print("Call rejected successfully: \(call.stringValue())")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Rejected call object is nil")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }) { (error) in
            print("Call rejection failed with error: \(error?.errorDescription ?? "")")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
