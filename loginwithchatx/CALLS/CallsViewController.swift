//
//  CallsViewController.swift
//  loginwithchatx
//
//  Created by Sandesh on 03/05/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class CallsViewController: UIViewController {
    
    var callSettings: CometChatCallsSDK.CallSettings?
    var incomingCall: Call?
    var callToken: String?
    var senderID: String?
    var senderImage: UIImage?
    var profileName: String?
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
    
    var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        //button.layer.cornerRadius = 50
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.sizeToFit()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.tintColor = .systemGreen
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone.down.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.cornerRadius = 50
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = .red
        button.imageView?.sizeToFit()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        button.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(acceptButton)
        view.addSubview(rejectButton)
    }
    
    private func setupConstraints() {
        view.isUserInteractionEnabled = true
        usernameLabel.text = profileName
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            acceptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            acceptButton.widthAnchor.constraint(equalToConstant: 50),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),
            
            rejectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            rejectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            rejectButton.widthAnchor.constraint(equalToConstant: 60),
            rejectButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        if let senderID = senderID {
            Helpers.getUser(forUID: senderID) { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.usernameLabel.text = user?.name
                }
            }
        }
    }
    
    func handleIncomingCall(_ incomingCall: Call) {
        self.incomingCall = incomingCall
    }
    
    @objc func acceptButtonTapped() {
        guard let incomingCall = self.incomingCall else { return }
        
        CometChat.acceptCall(sessionID: incomingCall.sessionID!, onSuccess: { [weak self] (acceptedCall) in
            guard let self = self else { return }
            
            if let call = acceptedCall {
                print("Call accepted successfully: \(call.stringValue())")
                
                DispatchQueue.main.async {
                    self.generateTokenAndStartCall()
                }
                
            } else {
                print("Accepted call object is nil")
            }
        }) { (error) in
            print("Call acceptation failed with error: \(error?.errorDescription ?? "")")
        }
    }
    
    func generateTokenAndStartCall() {
        guard let incomingCall = self.incomingCall else { return }
        let sessionId = incomingCall.sessionID!
        let authToken = CometChat.getUserAuthToken()
        
        CometChatCalls.generateToken(authToken: authToken as? NSString, sessionID: sessionId as NSString) { [weak self] token in
            guard let self = self else { return }
            self.callToken = token
            DispatchQueue.main.async {
                self.setupCallSettings()
                self.startCallSession()
            }
        } onError: { error in
            print("CometChatCalls generateToken error: \(String(describing: error?.errorDescription))")
        }
    }
    
    func setupCallSettings() {
        callSettings = CometChatCalls.callSettingsBuilder
            .setDefaultLayout(true)
            .setIsAudioOnly(false)
            .setIsSingleMode(false)
            .setShowSwitchToVideoCall(false)
            .setEnableVideoTileClick(true)
            .setEnableDraggableVideoTile(true)
            .setEndCallButtonDisable(false)
            .setShowRecordingButton(true)
            .setSwitchCameraButtonDisable(false)
            .setMuteAudioButtonDisable(false)
            .setPauseVideoButtonDisable(false)
            .setAudioModeButtonDisable(false)
            .setStartAudioMuted(true)
            .setStartVideoMuted(false)
            .setMode("DEFAULT")
            .setDefaultAudioMode("BLUETOOTH")
            .setDelegate(self)
            .build()
    }
    var callRunningView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func startCallSession() {
        guard let callToken = self.callToken, let callSettings = self.callSettings else { return }
        
        CometChatCalls.startSession(callToken: callToken, callSetting: callSettings, view: view) { [weak self] success in
            guard let self = self else { return }
            
            if success == "success" {
                print("CometChatCalls startSession success")
                self.setupCallRunningView()
                
            } else {
                print("CometChatCalls startSession failed: \(success)")
            }
        } onError: { error in
            print("CometChatCalls startSession error: \(String(describing: error?.errorDescription))")
        }
    }
    
    func setupCallRunningView() {
        view.addSubview(callRunningView)
        
        NSLayoutConstraint.activate([
            callRunningView.topAnchor.constraint(equalTo: view.topAnchor),
            callRunningView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callRunningView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            callRunningView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    @objc func rejectButtonTapped() {
        guard let incomingCall = self.incomingCall else {
            print("No incoming call to reject.")
            return
        }
        
        guard let sessionID = incomingCall.sessionID else {
            print("Incoming call has no session ID.")
            return
        }
        
        CometChat.rejectCall(sessionID: sessionID, status: .rejected, onSuccess: { (rejectedCall) in
            if let call = rejectedCall {
                print("Call rejected successfully: \(call.stringValue())")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Rejected call object is nil")
            }
        }) { (error) in
            print("Call rejection failed with error: \(error?.errorDescription ?? "")")
        }
    }
}
// These events will trigger only if user set the setDelegate(self) in callSettings.

extension CallsViewController: CallsEventsDelegate {
    
    func onCallEnded() {
        print("onCallEnded")
        DispatchQueue.main.async {
            self.dismiss(animated: true,completion: nil)
            self.callRunningView.removeFromSuperview()
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                Helpers.dismissCallsSenderViewController(from: rootViewController)
            }
        }
    }
    
    func onCallEndButtonPressed() {
        print("onCallEndButtonPressed one")
        DispatchQueue.main.async {
            self.dismiss(animated: true,completion: nil)
            self.callRunningView.removeFromSuperview()
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                Helpers.dismissCallsSenderViewController(from: rootViewController)
            }
        }
    }
    
    func onUserJoined(user: NSDictionary) {
        print("onUserJoined")
    }
    
    func onUserLeft(user: NSDictionary) {
        print("onUserLeft")
    }
    
    func onUserListChanged(userList: NSArray) {
        print("onUserListChanged")
    }
    
    func onAudioModeChanged(audioModeList: NSArray) {
        print("onAudioModeChanged")
    }
    
    func onCallSwitchedToVideo(info: NSDictionary) {
        print("onCallSwitchedToVideo")
    }
    
    func onUserMuted(info: NSDictionary) {
        print("onUserMuted")
    }
    
    func onRecordingToggled(info: NSDictionary) {
        print("onRecordingToggled")
    }
}
