//
//  ViewController.swift
//  loginwithchatx
//
//  Created by admin on 16/04/24.
//

import UIKit
import CometChatSDK


class LoginViewController: UIViewController {

    let uidTextField = UITextField()
    let loginButton = UIButton()
    private let logoView : UIImageView = {
        let logo = UIImageView()
        
        logo.clipsToBounds =  true
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "Logo")
        return logo
    }()
    private let logoTwoView : UIImageView = {
        let logo = UIImageView()
        
        logo.clipsToBounds =  true
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "LogoTwo")
        return logo
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        
         setupUI()
    }

    private func setupUI() {
        
        uidTextField.placeholder = "Enter UID"
        uidTextField.borderStyle = .roundedRect
        uidTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uidTextField)
        view.addSubview(logoView)
        view.addSubview(logoTwoView)
        NSLayoutConstraint.activate([
                logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
                logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoView.widthAnchor.constraint(equalToConstant: 220),
                logoView.heightAnchor.constraint(equalToConstant: 35)
            ])
        NSLayoutConstraint.activate([
            logoTwoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoTwoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTwoView.widthAnchor.constraint(equalToConstant: 160),
            logoTwoView.heightAnchor.constraint(equalToConstant: 160)
            ])
        NSLayoutConstraint.activate([
            
            
            
            uidTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uidTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            uidTextField.widthAnchor.constraint(equalToConstant: 350),
            uidTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: uidTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func loginButtonPressed() {
        guard let uid = uidTextField.text?.lowercased() else {
            return
        }

        let authKey = AppConstants.AUTH_KEY

        if CometChat.getLoggedInUser() == nil {
            CometChat.login(UID: uid, apiKey: authKey, onSuccess: { (user) in
                print("Login successful: " + user.stringValue())
//                CometChatNotifications.registerPushToken(pushToken: pushToken, platform: CometChatNotifications.PushPlatforms.FCM_IOS, providerId: "fcm-provider-1", onSuccess: { (success) in
//                  print("registerPushToken: \(success)")
//                }) { (error) in
//                  print("registerPushToken: \(error.errorCode) \(error.errorDescription)")
//                }
                DispatchQueue.main.async {
                    let textAreaViewController = TextAreaViewController()
                    
                    self.navigationController?.setViewControllers([textAreaViewController], animated: false)
                    textAreaViewController.navigationItem.setHidesBackButton(true, animated: false)
                    

                }
            }) { (error) in
                print("Login failed with error: " + error.errorDescription)
            }
            //        } else {
            //            print("User Is already logged in ")
            //            DispatchQueue.main.async {
            //                let textAreaViewController = TextAreaViewController()
            //                self.navigationController?.pushViewController(textAreaViewController, animated: true)
            //            }
            //        }
        }
    }
}
