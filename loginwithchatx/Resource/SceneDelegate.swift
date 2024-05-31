//
//  SceneDelegate.swift
//  loginwithchatx
//
//  Created by admin on 16/04/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let authKey = AppConstants.AUTH_KEY
    let appId = AppConstants.APP_ID
    let region = AppConstants.REGION
    var callRunningView: UIView?
    var callToken: String?
    var callSettings: CometChatCallsSDK.CallSettings?
    var currentPresentedViewController: UIViewController?
    let callVC =  CallsViewController()
    let loginViewController = LoginViewController()
    var isCallSetupInitiated = 0
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        CometChat.calldelegate = self
        CometChat.addCallListener("abc", self)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        if CometChat.getLoggedInUser() == nil {
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            loginViewController.navigationItem.setHidesBackButton(true, animated: false)
            DispatchQueue.main.async {
                navigationController.setViewControllers([loginViewController], animated: false)
                window.rootViewController = navigationController
            }
        } else {
            let textAreaViewController = TextAreaViewController()
            let navigationController = UINavigationController(rootViewController: textAreaViewController)
            textAreaViewController.navigationItem.setHidesBackButton(true, animated: false)
            DispatchQueue.main.async {
                navigationController.setViewControllers([textAreaViewController], animated: false)
                window.rootViewController = navigationController
            }
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        let mySettings = AppSettings.AppSettingsBuilder().subscribePresenceForAllUsers().setRegion(region: region).build()
        CometChat.init(appId: appId, appSettings: mySettings, onSuccess: { isSuccess in
            if isSuccess {
                print("CometChat Pro SDK initialized successfully.")
            }
        }) { error in
            print("CometChat Pro SDK initialization failed with error: \(error.errorDescription)")
        }
        
        let callAppSettings = CallAppSettingsBuilder()
            .setAppId(appId)
            .setRegion(region)
            .build()
        
        CometChatCalls.init(callsAppSettings: callAppSettings, onSuccess: { success in
            print("CometChatCalls init success: \(success)")
        }) { error in
            print("CometChatCalls init error: \(String(describing: error?.errorDescription))")
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    func generateTokenAndStartCall(for acceptedCall: Call) {
        let sessionId = acceptedCall.sessionID!
        let authToken = CometChat.getUserAuthToken() ?? ""
        //let callsViewController = CallsViewController()
        CometChatCalls.generateToken(authToken: authToken as NSString, sessionID: sessionId as NSString) { token in
            print("Token generated successfully: \(String(describing: token))")
            
            
            
            DispatchQueue.main.async {
                self.callToken = token
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
    func startCallSession() {
        guard let callToken = self.callToken, let callSettings = self.callSettings else { return }
        
        guard let window = self.window else { return }
        let callRunningView = UIView(frame: window.bounds)
        callRunningView.backgroundColor = .black
        callRunningView.translatesAutoresizingMaskIntoConstraints = false
        self.callRunningView = callRunningView
        window.addSubview(callRunningView)
        
        NSLayoutConstraint.activate([
            callRunningView.topAnchor.constraint(equalTo: window.topAnchor),
            callRunningView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            callRunningView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            callRunningView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        CometChatCalls.startSession(callToken: callToken, callSetting: callSettings, view: callRunningView, onSuccess: { success in
            DispatchQueue.main.async {
                print("CometChatCalls startSession success: \(success)")
            }
        }) { error in
            DispatchQueue.main.async {
                print("CometChatCalls startSession error: \(String(describing: error?.errorDescription))")
                callRunningView.removeFromSuperview()
            }
        }
    }
}

// Call Delegate Extension
extension SceneDelegate: CometChatCallDelegate {
    func onIncomingCallCancelled(canceledCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
        print("Incoming Call Cancelled" + (canceledCall?.stringValue() ?? ""))
        guard let incomingCall = canceledCall else {
            print("No incoming call to reject.")
            return
        }
        
        guard let sessionID = incomingCall.sessionID else {
            print("Incoming call has no session ID.")
            return
        }
        
        CometChat.rejectCall(sessionID: sessionID, status: .cancelled, onSuccess: { rejectedCall in
            if let call = rejectedCall {
                print("Call cancelled successfully: \(call.stringValue())")
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                        Helpers.dismissCallsViewController(from: rootViewController)
                    }
                }
            } else {
                print("Rejected call object is nil")
            }
        }) { error in
            print("Call rejection failed with error: \(error?.errorDescription ?? "")")
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                    Helpers.dismissCallsViewController(from: rootViewController)
                }
            }
        }
    }
    
    
    func onIncomingCallReceived(incomingCall: Call?, error: CometChatException?) {
        guard let incomingCall = incomingCall else {
            print("Error receiving incoming call: \(error?.errorDescription ?? "Unknown error")")
            return
        }
        
        let callsViewController = CallsViewController()
        callsViewController.modalPresentationStyle = .fullScreen
        callsViewController.handleIncomingCall(incomingCall)
        callsViewController.profileName = incomingCall.sender?.name
        
        if let user = incomingCall.sender, let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: avatarURL), let image = UIImage(data: data) {
                    
                    callsViewController.profileImageView.image = image
                    
                    
                } else {
                    
                    callsViewController.profileImageView.image = UIImage(named: "default_avatar")
                    
                }
            }
        } else {
            callsViewController.profileImageView.image = UIImage(named: "default_avatar")
        }
        
        if let rootViewController = self.window?.rootViewController {
            if let textAreaViewController = rootViewController.presentedViewController as? TextAreaViewController {
                textAreaViewController.present(callsViewController, animated: true)
            } else if let chatViewController = rootViewController.presentedViewController as? ChatViewController {
                chatViewController.present(callsViewController, animated: true)
            } else {
                rootViewController.present(callsViewController, animated: true)
            }
        }
    }
    
    func onOutgoingCallAccepted(acceptedCall: Call?, error: CometChatException?) {
        guard let acceptedCall = acceptedCall else {
            print("Error receiving outgoing call acceptance: \(error?.errorDescription ?? "Unknown error")")
            return
        }
        isCallSetupInitiated += 1
        
        if isCallSetupInitiated == 1 {
            print("onOutgoingCallAccepted \(acceptedCall.stringValue())")
            DispatchQueue.main.async {
                self.generateTokenAndStartCall(for: acceptedCall)
                self.isCallSetupInitiated = 0
            }
        }
        if CometChat.getActiveCall() == nil {
            print("onOutgoingCallAccepted \(acceptedCall.stringValue())")
            DispatchQueue.main.async {
                self.generateTokenAndStartCall(for: acceptedCall)
                self.isCallSetupInitiated = 0
            }
        } else {
            return
        }
    }
    
    func onOutgoingCallRejected(rejectedCall: Call?, error: CometChatException?) {
        guard let rejectedCall = rejectedCall else {
            print("Error receiving outgoing call rejection: \(error?.errorDescription ?? "Unknown error")")
            return
        }
        print("onOutgoingCallRejected \(rejectedCall.stringValue())")
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                Helpers.dismissCallsSenderViewController(from: rootViewController)
            }
            
        }
        
    }
    
    
    
    
    func onCallEndedMessageReceived(endedCall: Call?, error: CometChatException?) {
        guard let endedCall = endedCall else {
            print("Error receiving incoming call end: \(error?.errorDescription ?? "Unknown error")")
            return
        }
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                Helpers.dismissCallsSenderViewController(from: rootViewController)
            }
        }
        
        
        print("CallEnded \(endedCall.stringValue())")
    }
    
}
extension SceneDelegate: CallsEventsDelegate {
    
    func onCallEnded() {
        print("onCallEnded")
        
        //self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.callRunningView!.removeFromSuperview()
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                Helpers.dismissCallsSenderViewController(from: rootViewController)
            }
        }
        
    }
    
    func onCallEndButtonPressed() {
        print("onCallEndButtonPressed one")
        
        DispatchQueue.main.async {
            self.callRunningView!.removeFromSuperview()
            
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
